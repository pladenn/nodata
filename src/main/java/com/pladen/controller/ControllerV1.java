package com.pladen.controller;

import com.pladen.dto.Data;
import com.pladen.service.ActionProcessService;
import com.pladen.service.CommonHelper;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import lombok.experimental.FieldDefaults;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

import static lombok.AccessLevel.PRIVATE;

@Controller
@RequiredArgsConstructor
@FieldDefaults(makeFinal = true, level = PRIVATE)
public class ControllerV1 {
    ActionProcessService actionProcessService;
    CommonHelper commonHelper;

    public static final String BASE_PATH = "/content";

    //todo rename
    private static final String VIEW_NAME = "ggg";

    @SneakyThrows
    @Transactional
    @GetMapping( BASE_PATH + "/{context}/{code}")
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
    @GetMapping(BASE_PATH + "/{context}/{code}/parameters")
    public String actionViewParameters(@PathVariable("context") String context,
                                       @PathVariable("code") String code,
                                       @RequestParam Map<String, String> requestParams,
                                       Model model) {

        final Data mainData = actionProcessService.processParametersRequest(context, code, requestParams);
        model.addAttribute("mainData", commonHelper.objectToJson(mainData));
        return VIEW_NAME;
    }

    @SneakyThrows
    @Transactional
    @GetMapping(BASE_PATH + "/{context}/{code}/data")
    public @ResponseBody Data actionData(@PathVariable("context") String context,
                                         @PathVariable("code") String code,
                                         @RequestParam Map<String, String> requestParams) {

        return actionProcessService.processActionRequest(context, code, requestParams);
    }

}
