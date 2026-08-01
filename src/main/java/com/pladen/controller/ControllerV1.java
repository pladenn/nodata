package com.pladen.controller;

import static java.nio.charset.StandardCharsets.UTF_8;
import static java.util.Objects.nonNull;
import static lombok.AccessLevel.PRIVATE;
import static org.springframework.http.MediaType.APPLICATION_JSON;

import com.fasterxml.jackson.databind.JsonNode;
import com.pladen.dto.Data;
import com.pladen.service.ActionProcessService;
import com.pladen.service.CommonHelper;
import jakarta.servlet.http.HttpServletRequest;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import lombok.experimental.FieldDefaults;
import lombok.experimental.NonFinal;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequiredArgsConstructor
@FieldDefaults(makeFinal = true, level = PRIVATE)
public class ControllerV1 {
    ActionProcessService actionProcessService;
    CommonHelper commonHelper;

    @Autowired
    @NonFinal
    @Lazy
    ControllerV1 controllerV1;

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
    @PostMapping( BASE_PATH + "/{context}/{code}")
    public @ResponseBody Data actionView(@PathVariable("context") String context,
        @PathVariable("code") String code,
        @RequestBody Map<String, String> requestParams) {

        return actionProcessService.processActionRequest(context, code, requestParams);
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

  @SneakyThrows
  @Transactional
  @GetMapping(BASE_PATH + "/{context}/{code}/data/short")
  public @ResponseBody JsonNode actionShortData(@PathVariable("context") String context,
      @PathVariable("code") String code,
      @RequestParam Map<String, String> requestParams) {

    System.out.println("short " + code + " " + requestParams.toString());

    return actionProcessService.processActionRequest(context, code, requestParams)
        .getData();
  }

  @SneakyThrows
  @Transactional
  @GetMapping(BASE_PATH + "/{context}/{code}/data/short/first")
  public @ResponseBody JsonNode actionShortDataFirst(@PathVariable("context") String context,
      @PathVariable("code") String code,
      @RequestParam Map<String, String> requestParams) {

    System.out.println("short/index " + code + " " + requestParams.toString());
    return actionProcessService.processActionRequest(context, code, requestParams)
        .getData()
        .get(0);
  }

  @SneakyThrows
  @Transactional
  @PostMapping(BASE_PATH + "/{context}/{code}/data/short")
  public @ResponseBody JsonNode actionShortDataPost(@PathVariable("context") String context,
      @PathVariable("code") String code,
      @RequestBody Map<String, String> requestParams) {

    return actionProcessService.processActionRequest(context, code, requestParams)
        .getData();
  }

  @SneakyThrows
  @Transactional
  @PostMapping(BASE_PATH + "/{context}/{code}/data/short/first")
  public @ResponseBody JsonNode actionShortDataPostByIndex(@PathVariable("context") String context,
      @PathVariable("code") String code,
      @RequestBody Map<String, String> requestParams) {

    return actionProcessService.processActionRequest(context, code, requestParams)
        .getData()
        .get(0);
  }

  @SneakyThrows
  @RequestMapping("/**")
  public ResponseEntity<byte[]> proxyPath(HttpServletRequest request,
      @RequestBody(required = false) byte[] body) {

    System.out.println("Proxying request: " + request.getRequestURI());

    final JsonNode data = controllerV1.actionShortDataFirst("system",
        "http-proxy",
        Map.of(
            "uri", request.getRequestURI(),
            "method", request.getMethod(),
            "body", nonNull(body) ? new String(body, UTF_8) : ""
        ));

    return ResponseEntity.status(data.at("/status").asInt())
        .contentType(APPLICATION_JSON)
        .body(data.at("/body").asText().getBytes());
  }

}
