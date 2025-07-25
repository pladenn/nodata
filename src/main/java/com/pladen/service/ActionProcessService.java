package com.pladen.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.pladen.adapter.DataProvider;
import com.pladen.adapter.DataProviderInput;
import com.pladen.dto.ActionLinkMapping;
import com.pladen.dto.Column;
import com.pladen.dto.Parameter;
import com.pladen.dto.*;
import com.pladen.entity.ActionLink;
import com.pladen.entity.Dictionary;
import com.pladen.entity.*;
import com.pladen.repository.*;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import lombok.experimental.FieldDefaults;
import org.apache.commons.collections4.ListUtils;
import org.apache.commons.lang3.tuple.Pair;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.annotation.RequestScope;

import java.util.*;
import java.util.stream.Stream;

import static com.pladen.dto.Tab.DATA;
import static com.pladen.dto.Tab.PARAMETERS;
import static java.util.Collections.emptyList;
import static java.util.Objects.*;
import static java.util.function.UnaryOperator.identity;
import static java.util.stream.Collectors.toList;
import static java.util.stream.Collectors.toMap;
import static lombok.AccessLevel.PRIVATE;
import static org.apache.commons.lang3.ObjectUtils.defaultIfNull;
import static org.apache.commons.lang3.ObjectUtils.firstNonNull;

@Service
@RequestScope
@FieldDefaults(level = PRIVATE)
@RequiredArgsConstructor
public class ActionProcessService {
    private final ActionRepository actionRepository;
    private final ParameterRepository parameterRepository;
    @Qualifier("dataProviders")
    private final Map<String, DataProvider> dataProviders;
    private final ActionLinkRepository actionLinkRepository;
    private final ActionLinkMappingRepository actionLinkMappingRepository;
    private final DictionaryRepository dictionaryRepository;
    private final PropertyService propertyService;
    private final CommonHelper commonHelper;
    private final ColumnRepository columnRepository;

    private String currentContext;
    private Action currentAction;
    private Map<String, String> requestParameters;
    private final List<Parameter> parameters = new ArrayList<>();
    private List<Parameter> actionParameters;
    private Map<String, String> allParameters;
    private String[] propertyKeys;
    private String[] propertyValues;
    private Map<String, String> properties;

    private static final String SYSTEM_SUB_MENU_ACTION_PROPERTY = "system-sub-menu";
    private static final String CUSTOM_SUB_MENU_ACTION_PROPERTY = "custom-sub-menu";
    private static final String DEFAULT_DICTIONARY_NAME_COLUMN = "name";
    private static final String DEFAULT_DICTIONARY_VALUE_COLUMN = "value";

    private static final TypeReference<List<MenuItem>> MENU_TYPE = new TypeReference<>() {
    };

    @Transactional
    public Data processActionRequest(@NonNull String context, @NonNull String actionCode,
                                     @NonNull Map<String, String> requestParameters) {

        /*
         * set apply button
         * */

        final Data.DataBuilder dataBuilder = basicSetUp(context, actionCode, requestParameters);
        setParameters();
        setExtendedProperties();
        setDictionaryValues();
        setParameterTitles();

        final Pair<List<String>, List<Map<String, String>>> result = getData(currentAction, parameters);

        return dataBuilder
                .description(populateWithPropertiesAndParameterValues(currentAction.getDescription()))
                .parameters(getActionParameters())
                .actionParameters(getActionParameters().stream().collect(toMap(ParameterDto::getName, identity())))
                .systemParameters(getSystemParameters())
                .columns(getColumns(result.getLeft()))
                .data(result.getRight())
                .actionLinks(getActionLinkMappings())
                .tab(DATA)
                .postProcess(currentAction.getPostProcess())
                .redirect(populateWithPropertiesAndParameterValues(currentAction.getRedirect()))
                .build();
    }

    @Transactional
    public Data processParametersRequest(@NonNull String context, @NonNull String actionCode,
                                         @NonNull Map<String, String> requestParameters) {

        /*
         * set apply button
         * */

        final Data.DataBuilder dataBuilder = basicSetUp(context, actionCode, requestParameters)
                .columns(emptyList())
                .tab(PARAMETERS);

        setExtendedParameters();
        setExtendedProperties();
        setDictionaryValues();
        setParameterTitles();

        return dataBuilder
                .description(populateWithPropertiesAndParameterValues(currentAction.getDescription()))
                .parameters(getActionParameters())
                .actionParameters(getActionParameters().stream().collect(toMap(ParameterDto::getName, identity())))
                .systemParameters(getSystemParameters())
                .actionLinks(getActionLinkMappings())
                .postProcess(currentAction.getPostProcess())
//                .redirect(populateWithPropertiesAndParameterValues(currentAction.getRedirect()))
                .build();
    }

    @SneakyThrows
    private Data.DataBuilder basicSetUp(String context, String actionCode, Map<String, String> requestParameters) {
        this.currentAction = getActionByCode(actionCode);
        this.requestParameters = requestParameters;
        this.currentContext = context;
        setCurrentProperties();

        return Data.builder()
                .menuItems(getMenu())
                .originalUrl(requestParameters.get("_original_url"))
                .originalTitle(requestParameters.get("_original_title"));
    }

    private List<Column> getColumns(List<String> dataColumns) {
        final List<Column> columns = columnRepository.findByActionId(currentAction.getId())
                .stream()
                .sorted(Comparator.comparing(com.pladen.entity.Column::getOrder))
                .map(col -> new Column(col.getPath(), populateWithPropertiesAndParameterValues(col.getName())))
                .toList();

        if (!columns.isEmpty()) {
            return columns;
        }

        return dataColumns.stream()
                .map(Column::new)
                .toList();
    }

    private List<MenuItem> getMenu() {
        return ListUtils.union(
                getSubmenu(SYSTEM_SUB_MENU_ACTION_PROPERTY),
                getSubmenu(CUSTOM_SUB_MENU_ACTION_PROPERTY)
        );
    }

    private List<MenuItem> getSubmenu(String property) {
        return propertyService.getSystemProperty(property)
                .map(this::getData)
                .map(Pair::getValue)
                .map(List::getFirst)
                .map(Map::values)
                .map(Collection::stream)
                .flatMap(Stream::findAny)
                .map(json -> commonHelper.jsonToObject(json, MENU_TYPE))
                .orElseGet(List::of);
    }

    private Action getActionByCode(String actionCode) {
        return actionRepository.findByCodeOrElseThrow(actionCode);
    }

    private void setCurrentProperties() {
        final Map<String, String> properties = propertyService.mergeProperties(
                propertyService.getEnvironmentProperties(currentContext),
                propertyService.getAdditionalPropertiesForObject(currentAction.getId())
        );

        this.properties = properties;

        propertyKeys = properties.keySet().toArray(String[]::new);
        propertyValues = properties.values().toArray(String[]::new);
    }

    private void setExtendedProperties() {

    }

    private void setExtendedParameters() {
        setParameters();
    }

    private void setParameters() {
        final List<Parameter> params = parameterRepository.findByActionId(currentAction.getId())
                .stream()
                .sorted(Comparator.comparing(com.pladen.entity.Parameter::getOrder))
                .map(param -> new Parameter().setId(param.getId())
                        .setName(param.getName())
                        .setValue(
                                Optional.ofNullable(requestParameters.get(param.getName()))
                                        .orElseGet(() -> propertyService
                                                .populateWithProperties(populateWithProperties(param.getDefaultValue()), requestParameters))
                        )
                        .setType(param.getType())
                        .setEditable(param.getEditable())
                        .setParameter(param)

                )
                .toList();

        parameters.addAll(params);
    }

    private List<ParameterDto> getActionParameters() {
        return parameters.stream()
                .map(parameter -> ParameterDto.builder()
                        .id(parameter.getParameter().getId())
                        .name(parameter.getParameter().getName())
                        .title(parameter.getTitle())
                        .type(parameter.getParameter().getType())
                        .value(parameter.getValue())
                        .availableValues(parameter.getAvailableValues())
                        .editable(parameter.getParameter().getEditable())
                        .editableDictionary(parameter.getParameter().getEditableDictionary())
                        .build())
                .toList();
    }

/*    private List<Parameter> getActionParameters() {
        return requireNonNullElseGet(actionParameters,
                () -> {
                    evaluateAllParameters();
                    return actionParameters;
                });
    }*/

    private Map<String, String> getAllParameters() {
        return requireNonNullElseGet(allParameters,
                () -> {
                    evaluateAllParameters();
                    return allParameters;
                });
    }

    private Map<String, ParameterDto> getSystemParameters() {
        return Map.of(
                "action-code",
                ParameterDto.builder()
                        .name("action-code")
                        .value(currentAction.getCode())
                        .build()
        );
    }

    private void evaluateAllParameters() {
        final Pair<Map<String, String>, List<Parameter>> params = evaluateAllParameters(currentAction.getId(),
                requestParameters, true);

        allParameters = params.getLeft();

        actionParameters = params.getRight()
                .stream()
                .map(param -> Parameter.builder()
                        .id(param.getId())
                        .name(param.getName())
                        .value(param.getValue())
                        .type(param.getType())
                        .availableValues(param.getAvailableValues())
                        .title(populateWithPropertiesAndParameterValues(param.getTitle()))
                        .editable(param.getEditable())
                        .build())
                .toList();
    }

    private Pair<Map<String, String>, List<Parameter>> evaluateAllParameters(UUID actionId, Map<String, String> parameters, boolean addDictionaryValues) {
        final HashMap<String, String> params = new HashMap<>(parameters);

        final List<Parameter> actionParams = parameterRepository.findByActionId(actionId)
                .stream()
                .sorted(Comparator.comparing(com.pladen.entity.Parameter::getOrder))
                .map(parameter -> mapToParameterDto(parameter, parameters, addDictionaryValues))
                .collect(toList());

        actionParams.forEach(p -> params.put(p.getName(), p.getValue()));

        return Pair.of(params, actionParams);

    }

    private Parameter mapToParameterDto(com.pladen.entity.Parameter parameter, Map<String, String> parameters, boolean addDictionaryValues) {
        final Parameter.ParameterBuilder parameterBuilder = Parameter.builder()
                .id(parameter.getId())
                .name(parameter.getName())
                .value(
                        Optional.ofNullable(parameters.get(parameter.getName()))
                                .orElseGet(() -> propertyService
                                        .populateWithProperties(populateWithProperties(parameter.getDefaultValue()), parameters))
                )
                .type(parameter.getType())
                .title(parameter.getTitle())
                .editable(parameter.getEditable());

        return addDictionaryValues
                ? addDictionaryValues(parameterBuilder, parameter.getId(), parameters).build()
                : parameterBuilder.build();
    }

    private String populateWithPropertiesAndParameterValues(String source) {
        return propertyService.populateWithProperties(populateWithProperties(source), getAllParameters());
    }

    private Parameter.ParameterBuilder addDictionaryValues(Parameter.ParameterBuilder parameterBuilder,
                                                           UUID parameterId, Map<String, String> parameters) {
        final Dictionary dictionary = dictionaryRepository.findByParameterId(parameterId)
                .orElse(null);

        if (dictionary == null) {
            return parameterBuilder;
        }

        parameterBuilder.editable(dictionary.getEditable());

        final Map<String, String> mapping = dictionary.getDictionaryMappings()
                .stream()
                .collect(
                        HashMap::new,
                        (m, dictMapping) -> m.put(
                                dictMapping.getDictionaryParameter().getName(),
                                evaluateDictionaryParameterValue(dictMapping, parameters)
                        ),
                        Map::putAll
                );

        final String valueColumn = requireNonNullElse(dictionary.getValueColumn(), DEFAULT_DICTIONARY_VALUE_COLUMN);
        final String nameColumn = requireNonNullElse(dictionary.getNameColumn(), DEFAULT_DICTIONARY_NAME_COLUMN);

        final List<KeyValue> availableValues = getData(dictionary.getAction(), mapping)
                .getRight()
                .stream()
                .filter(row -> row.containsKey(valueColumn))
                .map(row -> new KeyValue(
                        row.getOrDefault(nameColumn, row.get(valueColumn)),
                        row.get(valueColumn)
                ))
                .collect(toList());

        return parameterBuilder.availableValues(availableValues);
    }

    private void setDictionaryValues() {

/*

final ObjectMapper objectMapper = new ObjectMapper();
objectMapper.readTree("json").at("/0/items/1/items")


* */




        parameters.stream()
                .filter(parameter -> nonNull(parameter.getParameter().getDictionaryLinkId()))
                .forEach(parameter -> {
                    final List<KeyValue> keyValues = getData(parameter.getParameter().getDictionaryLinkId(), parameters, properties)
                            .getRight()
                            .stream()
                            .map(row -> {

                                final String key = row.get(requireNonNullElse(parameter.getParameter().getNameColumn(), DEFAULT_DICTIONARY_NAME_COLUMN));
                                final String value = row.get(requireNonNullElse(parameter.getParameter().getValueColumn(), DEFAULT_DICTIONARY_VALUE_COLUMN));

                                return new KeyValue(
                                        defaultIfNull(key, value),
                                        value
                                );
                            })
                            .toList();

                    parameter.setAvailableValues(keyValues);
                });
    }

    private void setParameterTitles() {
        parameters.forEach(parameter -> parameter.setTitle(populateWithPropertiesAndParameterValues(parameter.getParameter().getTitle())));
    }

    private String evaluateDictionaryParameterValue(DictionaryMapping dictionaryMapping, Map<String, String> parameters) {
        if (isNull(dictionaryMapping)) {
            return null;
        }

        return Optional.ofNullable(dictionaryMapping.getActionParameter())
                .map(com.pladen.entity.Parameter::getName)
                .map(parameters::get)
                .orElseGet(
                        () -> propertyService
                                .populateWithProperties(populateWithProperties(dictionaryMapping.getDefaultValue()), parameters)
                );
    }

    private Pair<List<String>, List<Map<String, String>>> getData() {
        return null;//getData(currentAction, getActionParameters());
    }

    private Pair<List<String>, List<Map<String, String>>> getData(String actionCode) {
        return getData(getActionByCode(actionCode), getAllParameters());
    }

    private Pair<List<String>, List<Map<String, String>>> getData(Action action, Map<String, String> parameterValues) {
        return getData(action,
                evaluateAllParameters(action.getId(), parameterValues, false).getRight());
    }

    private Pair<List<String>, List<Map<String, String>>> getData(Action action, List<Parameter> parameters) {
        final DataProviderInput input = getDataSupplierInputBuilder(action.getConnection())
                .method(action.getExecution_type())
                .query(populateWithProperties(action.getQuery()))
                .content(populateWithProperties(action.getContent()))
                .parameters(parameters)
                .properties(
                        propertyService.mergeProperties(properties,
                                propertyService.getAdditionalPropertiesForObject(action.getId()),
                                propertyService.getAdditionalPropertiesForObject(action.getConnection().getId()))
                )
                .build();

        return dataProviders.get(action.getConnection().getType())
                .getData(input);
    }

    private Pair<List<String>, List<Map<String, String>>> getData(UUID actionLinkId, List<Parameter> parameters,
                                                                  Map<String, String> properties) {

        final List<com.pladen.entity.ActionLinkMapping> actionLinkMappings = actionLinkMappingRepository.findByActionLinkId(actionLinkId);

        return actionLinkRepository.findById(actionLinkId)
                .map(ActionLink::getChildAction)
                .flatMap(v -> Optional.ofNullable(dataProviders.get(v.getConnection().getType()))
                        .map(dp -> dp.getData(
                                DataProviderInput.builder()
                                        .url(populateWithProperties(v.getConnection().getUrl()))
                                        .login(populateWithProperties(v.getConnection().getLogin()))
                                        .password(populateWithProperties(v.getConnection().getPassword()))
                                        .method(v.getExecution_type())
                                        .query(propertyService.populateWithProperties(v.getQuery(), properties))
                                        .content(propertyService.populateWithProperties(v.getContent(), properties))
                                        .parameters(mapParameters(v, actionLinkMappings, parameters, properties))
                                        .properties(
                                                propertyService.mergeProperties(properties,
                                                        propertyService.getAdditionalPropertiesForObject(v.getConnection().getId()))
                                        )
                                        .build()
                        ))


                )
                .orElseGet(() -> Pair.of(List.of(), List.of()));
    }

    private List<Parameter> mapParameters(Action action, List<com.pladen.entity.ActionLinkMapping> mappings,
                                          List<Parameter> parameters, Map<String, String> properties) {

        final Map<String, com.pladen.entity.ActionLinkMapping> actionLinkMappingMap = mappings.stream()
                .collect(toMap(
                        k -> k.getParameter().getName(),
                        identity()
                ));


        final Map<String, String> params = parameters.stream()
                .filter(parameter -> nonNull(parameter.getValue()))
                .collect(toMap(
                        Parameter::getName,
                        Parameter::getValue
                ));

        return parameterRepository.findByActionId(action.getId())
                .stream()
                .map(parameter -> new Parameter()
                        .setId(parameter.getId())
                        .setName(parameter.getName())
                        .setType(parameter.getType())
                        .setTitle(parameter.getTitle())
                        .setValue(
                                //todo populate with props, variables, params
                                Optional.of(parameter.getName())
                                        .map(actionLinkMappingMap::get)
                                        .map(link -> {
                                            String val = null;

                                            if (nonNull(link.getMapping())) {
                                                val = params.get(link.getMapping());
                                            } else {
                                                val = link.getDefaultValue();
                                            }

                                            return val;
                                        })
                                        .or(() -> Optional.ofNullable(parameter.getDefaultValue()))
                                        .map(v -> propertyService.populateWithProperties(v, properties))
                                        .orElse(null)
                        )
                        .setParameter(parameter)
                )
                .toList();
    }

    private String populateWithProperties(String source) {
        return propertyService.populateWithProperties(source, properties);
    }

    private DataProviderInput.DataProviderInputBuilder getDataSupplierInputBuilder(Connection connection) {
        return DataProviderInput.builder()
                .url(populateWithProperties(connection.getUrl()))
                .login(populateWithProperties(connection.getLogin()))
                .password(populateWithProperties(connection.getPassword()));
    }

    private List<com.pladen.dto.ActionLink> getActionLinkMappings() {
        final String baseUrl = "/content/" + currentContext + "/";

        return actionLinkRepository.findLinks(currentAction.getId())
                .stream()
                .map(val ->
                        com.pladen.dto.ActionLink.builder()
                                .path(baseUrl + val.getChildAction().getCode()
                                        + (val.isViaParameters() ? "/parameters" : ""))
                                .title(
                                        populateWithPropertiesAndParameterValues(
                                                firstNonNull(val.getTitle(), val.getChildAction().getDescription(), val.getChildAction().getTitle()))
                                )
                                .mapping(getParameterMappings(val))
                                .isActionTarget(val.isActionTarget())
                                .build()
                )
                .collect(toList());
    }

    private List<ActionLinkMapping> getParameterMappings(ActionLink actionLink) {
        return actionLinkMappingRepository.findByActionLinkId(actionLink.getId())
                .stream()
                .map(linkMapping -> ActionLinkMapping.builder()
                        .parameterName(linkMapping.getParameter().getName())
                        .path(linkMapping.getMapping())
                        .defaultValue(populateWithPropertiesAndParameterValues(linkMapping.getDefaultValue()))
                        .build())
                .toList();
    }

}