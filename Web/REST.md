# REST(representational state transfer)

**서버와 클라이언트가 HTTP를 적극 활용해서 통신하는 아키텍처**

* REST 원칙을 준수하면 API 의미를 표현하고 파악하는 것이 쉽다.
* 자원(URI), 행위(HTTP METHOD), 표현(Representations)으로 구성된다.

## REST API 설계 시 중요한 부분

**URI는 자원을 표현하는데 중점을 두고, 행위는 HTTP Method로 표현한다.**

* URI에 CRUD를 명시적으로 사용하는 것이 아니라, HTTP METHOD를 적극 활용한다.
    * 동일한 자원은 동일한 uri이지만, HTTP METHOD에 따라 다르게 동작한다.
* URI는 네이밍 규칙에 따라 경로를 설정한다.
    * '/'는 계층 관계를 나타낸다.
    * URI 마지막 문자로 슬래시(/)를 포함하지 않는다.
    * 하이픈(-)은 URI 가독성을 높이는데 사용하며, 밑줄(_)은 사용하지 않는다.
    * URI 경로에는 소문자가 적합하다.
    * 파일 확장자는 URI에 포함시키지 않는다.
* Collection과 Document 사용시, 단수와 복수를 지켜주는 것이 좋다.
    * ex) http:// restapi.example.com/sports/soccer

## HTTP 응답 상태 코드

* URI만 잘 설계하는 것이 아니라 리소스에 대한 응답까지 잘해야 한다.
* 정확한 상태코드만 응답해도 많은 정보를 전달할 수 있다.
* 포괄적인 상태코드 보다 좀 더 명확한 상태코드를 사용하는 것이 좋다.
