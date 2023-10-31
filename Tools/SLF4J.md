# SLF4J

**로그 기능을 추상화**

* LoggerFactory.getLogger() 메서드에 로그를 사용할 클래스를 매개변수로 전달하면 Logger를 획득
  * 롬복이 제공하는 `@SLF4J`를 사용하면 Logger를 자동으로 생성해준다.

# logback

* log4j의 후속작
* 세 가지 모듈로 구분
  * logback-core: logback의 핵심 모듈
  * logback-classic: 기존의 log4j를 개선한 것과 대응하며, core 모듈을 확장한다.
  * logback-access: 서블릿 컨테이너와 통합되어 HTTP 액세스 로그 기능을 제공한다.
* configuration 라이브러리인 Joran을 의존
  * logback.xml으로 작성한 설정 파일에서 `JoranConfigurator`를 호출

## Logger

* classic 모듈에 존재
  * log4j에 이미 있었기 때문에 core가 아닌 classic 모듈에 존재
* 같은 이름의 Logger는 항상 동일한 참조를 가진다.
* 로그 메시지는 문자열 연산 대신 매개 변수 형식으로 작성해야 한다.
  * 매개 변수 형식으로 작성하면 지연처리 가능 
  * 30배 이상 성능 향상
* 심각도에 따라 5단계로 구분
  * `TRACE`, `DEBUG`, `INFO`, `WARN`, `ERROR`

## Appender

* core 모듈에 존재
* **ConsoleAppender**: PrintStream을 사용하여 Console에 로그를 남기는 Appender
* **FileAppender**: 로그를 파일로 남기는 Appender

### RollingFileAppender
**rollover를 이용해서 특정 조건(시간, 공간)이 되면 로그를 쌓던 타겟 파일을 그 다음 파일로 변경**

  * **RollingPolicy**: rollover를 어떻게 실행할지를 정의
  * **TriggeringPolicy**: 언제 rollover를 발생시킬지를 정의

### Encoder

**로깅 이벤트를 바이트 배열로 변환**

* 기존의 layout 대신 사용
  * layout은 바이너리가 아닌 범위만 String으로 출력
* `LayoutWrappingEncoder`로 layout과 호환 지원
* 기본 encoder는 `PatternLayoutEncoder`
  * `DefaultLogbackConfiguration` 내부에서 확인 가능