# ArgumentResolver

**컨트롤러 호출에 필요한 매개변수를 생성하고 전달**

* HandlerMethodArgumentResolver 인터페이스를 구현하며, 30가지 이상으로 다양하게 제공된다.
* RequestMappingHandlerAdaptor(어노테이션 기반으로 컨트롤러를 처리)에 의해 호출된다.
    * 컨트롤러 호출에 필요한 매개변수를 확인하고, 처리가능한 ArgumentResolver를 찾는다.
    * ArgumentResolver는 supportsParameter() 메서드로 매개변수 지원여부를 확인한다.
* ArgumentResolver가 생성한 매개변수는 RequestMappingHandlerAdaptor로 전달된다.
    * @RequestBody, HttpEntity 등 body에 있는 데이터를 처리할 때, **HTTP 메시지 컨버터**가 사용된다.
    * 서로 다른 ArgumentResolver에서 HTTP 메시지 컨버터가 사용된다.
* RequestMappingHandlerAdaptor는 컨트롤러를 호출하면서 전달 받은 매개변수를 넘겨준다.