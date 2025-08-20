# Interceptors

```
public class PostHookInterceptor implements HandlerInterceptor {

    private static final String PATH_VARIABLES_ATTRIBUTE = "org.springframework.web.servlet.View.pathVariables";

    private final List<RequestPostHook> postHooks;
    private final ObjectMapper objectMapper;

    @Override
    public void postHandle(@NotNull HttpServletRequest request,
                           @NotNull HttpServletResponse response,
                           @NotNull Object handler,
                           ModelAndView modelAndView) throws Exception {
        try {
            var method = request.getMethod();
            var path = (String) request.getAttribute(HandlerMapping.BEST_MATCHING_PATTERN_ATTRIBUTE);
            for (RequestPostHook<Object> postHook : postHooks) {
                try {
                    if (postHook.isTargetEndpoint(method, path)) {
                        var pathVariables = (Map<String, String>) request.getAttribute(PATH_VARIABLES_ATTRIBUTE);
                        var payload = objectMapper.readValue(request.getReader(), postHook.getPayloadType());

                        postHook.process(pathVariables, payload);
                    }
                } catch (Exception e) {
                    log.error("Error during processing Post Hook '{}': {}", postHook.getClass().getSimpleName(), e.getMessage(), e);
                }
            }
        } catch (Exception e) {
            log.error("Error during processing Post Hooks: {}", e.getMessage(), e);
        }
    }

}
```

