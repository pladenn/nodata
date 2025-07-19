package com.pladen.controller;

import com.pladen.dto.Data;
import com.pladen.dto.DataBaseQuery;
import com.pladen.service.ActionProcessService;
import com.pladen.service.CommonHelper;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import lombok.experimental.FieldDefaults;
import org.apache.commons.lang3.tuple.Pair;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

import static lombok.AccessLevel.PRIVATE;

@Controller
@RequiredArgsConstructor
@FieldDefaults(makeFinal = true, level = PRIVATE)
public class ControllerV1 {
    ActionProcessService actionProcessService;
    CommonHelper commonHelper;

    //todo rename
    private static final String VIEW_NAME = "ggg";

    @SneakyThrows
    @Transactional
    @GetMapping("/content/{context}/{code}")
    public String actionView(@PathVariable("context") String context,
                             @PathVariable("code") String code,
                             @RequestParam Map<String, String> requestParams,
                             Model model) {

        final Data mainData = actionProcessService.processActionRequest(context, code, requestParams);
        model.addAttribute("mainData", commonHelper.objectToJson(mainData));
        return VIEW_NAME;
    }

    @SneakyThrows
    @Transactional
    @GetMapping("/content/{context}/{code}/parameters")
    public String actionViewParameters(@PathVariable("context") String context,
                                       @PathVariable("code") String code,
                                       @RequestParam Map<String, String> requestParams,
                                       Model model) {

        final Data mainData = actionProcessService.processParametersRequest(context, code, requestParams);
        model.addAttribute("mainData", commonHelper.objectToJson(mainData));
        return VIEW_NAME;
    }

    @PostMapping("/data-base-query/{context}")
    public @ResponseBody Pair<List<String>, List<Map<String, String>>> dataBaseQuery(
        @PathVariable("context") String context,
        @RequestBody DataBaseQuery query) {
        return Pair.of(List.of("column", "xxx"), List.of(Map.of("column", "value", "column1", "value1")));
    }

}
