# 스프링이 제공하는 WAS

WAS란 웹 애플리케이션 서버로 **DB와 연결되어 데이터를 동적으로 가져와 정적 페이지를 생성**한다.

## Tomcat

* Java Servlet, JavaServer Pages(JSP), Java Expression Language, Java WebSocket 기술을 지원한다.
* 7 버전까지 대규모 트래픽에서 불안정하다는 의견이 있었지만, 9버전부터는 안정화되었다.
* 자바 진영에서 가장 널리 사용되는 WAS로 방대한 참고자료가 있다.
* 스프링 부트도 기본 내장 WAS로 Tomcat을 사용한다.

## Jetty

* 경량급 WAS로 메모리를 적게 사용하기 때문에 가볍고 빠르다.
* 소형 장비, 소규모 프로그램 등에서 사용하기 좋다.
* 경량급 WAS이기 때문에 대규모 트래픽에는 취약하다.

## Undertow

* 고성능 웹서버로 대규모 트래픽을 Tomcat보다 안정적으로 처리한다고 평가받는다.
* Blocking과 Non-Blocking API를 안정적으로 제공한다.

## Netty

* 비동기, 이벤트 처리 방식의 네트워크 애플리케이션 프레임워크다.
* Webflux를 사용하면 기본 내장 WAS는 Netty가 된다.
* Undertow도 Netty 기반이에요.