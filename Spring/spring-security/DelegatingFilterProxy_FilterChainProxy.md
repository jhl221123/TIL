# DelegatingFilterProxy

**표준 서블릿 컨테이너와 스프링 컨테이너의 다리 역할**

* 스프링 시큐리티는 FilterChain을 서블릿 컨테이너 기반의 필터 위에서 동작시키기 위해 DelegatingFilterProxy를 사용한다.
* DelegatingFilterProxy는 스프링 컨테이너에서 관리하는 빈이 아니며, 표준 서블릿 필터를 구현하고 있다.
* DelegatingFilterProxy는 서블릿 컨테이너의 필터 체인에 속한다.
  * DelegatingFilterProxy 내부의 FilterChainProxy는 스프링 시큐리티가 제공하는 필터 체인으로 스프링 컨테이너에 속한다.
* FilterChainProxy 빈이 있어야지만 DelegatingFilterProxy를 생성할 수 있다.
  * SecurityFilterAutoConfiguration을 통해서 DelegatingFilterProxyRegistrationBean 빈을 생성한다.
  * DelegatingFilterProxyRegistrationBean은 ServletContextInitializer을 통해 서블릿 컨테이너의 필터체인에 DelegatingFilterProxy을 등록한다.

