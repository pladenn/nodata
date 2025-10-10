package com.pladen.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.pladen.adapter.DataProvider;
import com.pladen.adapter.DataProviderInput;
import com.pladen.dto.*;
import com.pladen.entity.Action;
import com.pladen.entity.ActionLink;
import com.pladen.repository.*;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.apache.commons.collections4.ListUtils;
import org.apache.commons.lang3.tuple.Pair;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

import static com.pladen.controller.ControllerV1.BASE_PATH;
import static com.pladen.dto.ExecutionContext.getNullableStringValue;
import static com.pladen.dto.Tab.DATA;
import static com.pladen.dto.Tab.PARAMETERS;
import static java.util.Collections.emptyList;
import static java.util.Objects.isNull;
import static java.util.Objects.requireNonNullElse;
import static java.util.function.UnaryOperator.identity;
import static java.util.stream.Collectors.toList;
import static java.util.stream.Collectors.toMap;
import static lombok.AccessLevel.PRIVATE;
import static org.apache.commons.lang3.ObjectUtils.*;
import static org.apache.commons.lang3.StringUtils.isNoneBlank;

@Service
@FieldDefaults(level = PRIVATE)
@RequiredArgsConstructor
public class ActionProcessService {
    private final ActionRepository actionRepository;
    private final ParameterRepository parameterRepository;
    @Qualifier("dataProviders")
    private final Map<String, DataProvider> dataProviders;
    private final ActionLinkRepository actionLinkRepository;
    private final ActionLinkMappingRepository actionLinkMappingRepository;
    private final PropertyService propertyService;
    private final CommonHelper commonHelper;
    private final ColumnRepository columnRepository;
    private final ObjectMapper objectMapper;

    private static final String SYSTEM_SUB_MENU_ACTION_PROPERTY = "system-sub-menu";
    private static final String CUSTOM_SUB_MENU_ACTION_PROPERTY = "custom-sub-menu";
    private static final String DEFAULT_DICTIONARY_NAME_COLUMN = "name";
    private static final String DEFAULT_DICTIONARY_VALUE_COLUMN = "value";

    private static final String DATA_EXECUTION_GROUP = "DATA";
    private static final String INITIALIZATION_EXECUTION_GROUP = "INITIALIZATION";
    private static final String PARAMETERS_EXECUTION_GROUP = "PARAMETERS";

    private static final String MOUNTED_TO_ACTION_EXECUTION_GROUP = "MOUNTED_TO_ACTION";
    private static final String MOUNTED_TO_ROW_EXECUTION_GROUP = "MOUNTED_TO_ROW";

    private static final TypeReference<List<MenuItem>> MENU_TYPE = new TypeReference<>() {
    };

    @Transactional
    public Data processActionRequest(@NonNull String context, @NonNull String actionCode,
                                     @NonNull Map<String, String> requestParameters) {

        /*
         *todo  set apply button
         * */

        final Action action = getActionByCode(actionCode);

        final ExecutionContext executionContext = executeAction(action.getId(), requestParameters, context);

        final List<ParameterDto> actionParameters = getActionParameters(executionContext);

        return Data.builder()
                .menuItems(getMenu(executionContext))
                .originalUrl(requestParameters.get("_original_url"))
                .originalTitle(requestParameters.get("_original_title"))
                .description(executionContext.populatePlaceholders(action.getDescription()))
                .parameters(actionParameters)
                .actionParameters(actionParameters.stream().collect(toMap(ParameterDto::getName, identity())))
                .systemParameters(getSystemParameters(actionCode))
                .columns(getColumns(executionContext))
                .data(executionContext.getData().orElse(null))
                .actionLinks(getActionLinkMappings(executionContext))
                .tab(DATA)
                .postProcess(action.getPostProcess())
                .redirect(executionContext.populatePlaceholders(action.getRedirect()))
                .build();
    }

    @Transactional
    public Data processParametersRequest(@NonNull String context, @NonNull String actionCode,
                                         @NonNull Map<String, String> requestParameters) {

        /*
         *todo set apply button
         * */

        final Action action = getActionByCode(actionCode);

        final ExecutionContext executionContext = executeAction(action.getId(), requestParameters, context, PARAMETERS_EXECUTION_GROUP);

        setExtendedParameterValues(executionContext);

        final List<ParameterDto> actionParameters = getActionParameters(executionContext);

        return Data.builder()
                .menuItems(getMenu(executionContext))
                .originalUrl(requestParameters.get("_original_url"))
                .originalTitle(requestParameters.get("_original_title"))
                .columns(emptyList())
                .tab(PARAMETERS)
                .description(executionContext.populatePlaceholders(action.getDescription()))
                .parameters(actionParameters)
                .actionParameters(actionParameters.stream().collect(toMap(ParameterDto::getName, identity())))
                .systemParameters(getSystemParameters(actionCode))
                .actionLinks(getActionLinkMappings(executionContext))
                .postProcess(action.getPostProcess())
                .build();
    }

    private void setExtendedParameterValues(ExecutionContext context) {
        context.getValue(PARAMETERS_EXECUTION_GROUP)
                .map(ExecutionContext::nodeToList)
                .orElseGet(List::of)
                .forEach(node -> context.getParameters()
                        .stream()
                        .filter(parameter -> isNull(parameter.getValue()))
                        .forEach(parameter -> ExecutionContext.getStringValue(node, parameter.getName())
                                .ifPresent(parameter::setValue)
                        ));
    }

    private List<Column> getColumns(ExecutionContext context) {
        final List<Column> columns = columnRepository.findByActionId(context.getActionId())
                .stream()
                .sorted(Comparator.comparing(com.pladen.entity.Column::getOrder))
                .map(col -> new Column(col.getPath(), context.populatePlaceholders(col.getName())))
                .toList();

        if (!columns.isEmpty()) {
            return columns;
        }

        return context.getColumns()
                .stream()
                .map(Column::new)
                .toList();
    }

    private List<MenuItem> getMenu(ExecutionContext context) {
        return ListUtils.union(
                getSubmenu(SYSTEM_SUB_MENU_ACTION_PROPERTY, context),
                getSubmenu(CUSTOM_SUB_MENU_ACTION_PROPERTY, context)
        );
    }

    private List<MenuItem> getSubmenu(String property, ExecutionContext context) {
        return context.getSystemProperty(property)
                .map(actionCode -> executeAction(getActionByCode(actionCode).getId(), Map.of(), "system"))
                .map(ExecutionContext::getDataAsList)
                .map(List::getFirst)
                .map(v -> v.get("menu"))
                .map(JsonNode::toString)
                .map(json -> commonHelper.jsonToObject(json, MENU_TYPE))
                .orElseGet(List::of);
    }

    private Action getActionByCode(String actionCode) {
        return actionRepository.findByCodeOrElseThrow(actionCode);
    }

    private Action getActionById(UUID actionId) {
        return actionRepository.findByIdOrElseThrow(actionId);
    }

    private ExecutionContext executeAction(UUID actionId, Map<String, String> requestParameters, String environment) {
        return executeAction(actionId, requestParameters, environment, DATA_EXECUTION_GROUP);
    }

    private ExecutionContext executeAction(UUID actionId, Map<String, String> requestParameters, String environment, String group) {

        final ExecutionContext executionContext = new ExecutionContext(objectMapper)
                .setEnvironment(environment)
                .setActionId(actionId)
                .putRequestParameters(requestParameters);

        setProperties(executionContext);
        executionContext.putParameters(getParameters(executionContext));

        executeGroup(executionContext, INITIALIZATION_EXECUTION_GROUP);

        return executeGroup(executionContext, requireNonNullElse(group, DATA_EXECUTION_GROUP));
    }

    private ExecutionContext executeGroup(ExecutionContext context, String group) {

        if (anyNull(context, group)) {
            return context;
        }

        final List<ActionLink> links = actionLinkRepository.findByParentActionIdAndCategory(context.getActionId(), group);

        if (links.isEmpty() && DATA_EXECUTION_GROUP.equals(group)) {
            return context.putData(getData(context));
        }

        links.forEach(link -> getDataByLink(link, context)
                .filter(ignore -> isNoneBlank(link.getVariable()))
                .map(data -> context.putValueByPath(data, link.getVariable())));

        return context;
    }

    private Pair<List<String>, JsonNode> getData(ExecutionContext context) {
        final Action action = getActionById(context.getActionId());

        final DataProviderInput input = DataProviderInput.builder()
                .url(context.populatePlaceholders(action.getConnection().getUrl()))
                .login(context.populatePlaceholders(action.getConnection().getLogin()))
                .password(context.populatePlaceholders(action.getConnection().getPassword()))
                .method(action.getExecution_type())
                .query(context.populatePlaceholders(action.getQuery()))
                .content(context.populatePlaceholders(action.getContent()))
                //todo are parameters needed here? they are in the execution context
                .parameters(context.getParameters())
                .executionContext(context)
                .build();

        return dataProviders.get(action.getConnection().getType())
                .getData(input);
    }

    private void setProperties(ExecutionContext context) {
        context.putSystemProperties(propertyService.getApplicationProperties());

        context.putSystemProperties(propertyService.getSystemProperties());

        context.putEnvironmentProperties(propertyService.getEnvironmentProperties(context.getEnvironment()));

        context.putProperties(propertyService.getAdditionalPropertiesForObject(context.getActionId()));

        context.putProperties("properties.connection",
                propertyService.getAdditionalPropertiesForObject(getActionById(context.getActionId())
                        .getConnection()
                        .getId()));
    }

    private List<Parameter> getParameters(ExecutionContext context) {
        return parameterRepository.findByActionId(context.getActionId())
                .stream()
                .sorted(Comparator.comparing(com.pladen.entity.Parameter::getOrder))
                .map(param -> new Parameter().setId(param.getId())
                        .setName(param.getName())
                        .setValue(context.getRequestParameter(param.getName())
                                .orElseGet(() -> context.populatePlaceholders(param.getDefaultValue()))
                        )
                        .setTitle(param.getTitle())
                        .setType(param.getType())
                        .setEditable(param.getEditable())
                        .setOrder(param.getOrder())
                        .setEditableDictionary(param.getEditableDictionary())
                        .setDictionaryLinkId(param.getDictionaryLinkId())
                        .setDictionaryNameColumn(param.getNameColumn())
                        .setDictionaryValueColumn(param.getValueColumn())
                )
                .toList();
    }

    private List<ParameterDto> getActionParameters(ExecutionContext context) {
        return context.getParameters()
                .stream()
                .map(parameter -> ParameterDto.builder()
                        .id(parameter.getId())
                        .name(parameter.getName())
                        .title(context.populatePlaceholders(parameter.getTitle()))
                        .type(parameter.getType())
                        .value(parameter.getValue())
                        .availableValues(getDictionaryValues(parameter, context))
                        .editable(parameter.getEditable())
                        .editableDictionary(parameter.getEditableDictionary())
                        .build())
                .toList();
    }

    private Map<String, ParameterDto> getSystemParameters(String actionCode) {
        return Map.of(
                "action-code",
                ParameterDto.builder()
                        .name("action-code")
                        .value(actionCode)
                        .build()
        );
    }

    private List<KeyValue> getDictionaryValues(Parameter parameter, ExecutionContext context) {
        if (isNull(parameter) || isNull(parameter.getDictionaryLinkId())) {
            return null;
        }

        return Optional.of(parameter)
                .map(Parameter::getDictionaryLinkId)
                .flatMap(actionLinkRepository::findById)
                .flatMap(link -> getDataByLink(link, context))
                .map(ExecutionContext::nodeToList)
                .orElseGet(List::of)
                .stream()
                .filter(JsonNode::isObject)
                .map(ObjectNode.class::cast)
                .map(obj -> new KeyValue(
                    getNullableStringValue(obj, requireNonNullElse(parameter.getDictionaryNameColumn(), DEFAULT_DICTIONARY_NAME_COLUMN)) ,
                    getNullableStringValue(obj, requireNonNullElse(parameter.getDictionaryValueColumn(), DEFAULT_DICTIONARY_VALUE_COLUMN))
                ))
                .toList();
    }

    private Optional<JsonNode> getDataByLink(ActionLink link, ExecutionContext executionContext) {

        final Map<String, String> requestParameters = actionLinkMappingRepository.findByActionLinkId(link.getId())
                .stream()
                .filter(mapping -> anyNotNull(mapping.getMapping(), mapping.getDefaultValue(), mapping.getParameter().getDefaultValue()))
                .collect(
                        toMap(
                                k -> k.getParameter().getName(),
                                mapping -> Optional.ofNullable(mapping.getMapping())
                                        .flatMap(executionContext::getStringValue)
                                        .or(() -> Optional.ofNullable(
                                                executionContext.populatePlaceholders(mapping.getDefaultValue())))
                                        .or(() -> Optional.ofNullable(
                                                executionContext.populatePlaceholders(mapping.getParameter()
                                                        .getDefaultValue())))
                                        .orElse(null)
                        )
                );

        return executeAction(link.getChildAction().getId(), requestParameters, executionContext.getEnvironment(),
                link.getChildAction().getId().equals(executionContext.getActionId()) ? null : DATA_EXECUTION_GROUP).getData();
    }

    private List<com.pladen.dto.ActionLink> getActionLinkMappings(ExecutionContext context) {
        final String baseUrl = BASE_PATH + "/" + context.getEnvironment() + "/";

        return actionLinkRepository.findByParentActionIdAndCategoryIn(context.getActionId(),
                        List.of(MOUNTED_TO_ACTION_EXECUTION_GROUP, MOUNTED_TO_ROW_EXECUTION_GROUP))
                .stream()
                .map(val ->
                        com.pladen.dto.ActionLink.builder()
                                .path(baseUrl + val.getChildAction().getCode()
                                        + (val.isViaParameters() ? "/parameters" : ""))
                                .title(
                                        context.populatePlaceholders(
                                                firstNonNull(val.getTitle(), val.getChildAction().getDescription(), val.getChildAction().getTitle()))
                                )
                                .mapping(getParameterMappings(val, context))
                                .isActionTarget(MOUNTED_TO_ACTION_EXECUTION_GROUP.equals(val.getCategory()))
                                .build()
                )
                .collect(toList());
    }

    private List<ActionLinkMapping> getParameterMappings(ActionLink actionLink, ExecutionContext context) {
        return actionLinkMappingRepository.findByActionLinkId(actionLink.getId())
                .stream()
                .map(linkMapping -> ActionLinkMapping.builder()
                        .parameterName(linkMapping.getParameter().getName())
                        .path(linkMapping.getMapping())
                        .defaultValue(context.populatePlaceholders(linkMapping.getDefaultValue()))
                        .build())
                .toList();
    }

}