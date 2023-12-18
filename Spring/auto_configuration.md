# 자동 구성(Auto Configuration)

**라이브러리의 핵심 빈을 자동으로 구성할 수 있도록 지원하는 기능**
* `@AutoConfiguration` 어노테이션으로 자동 구성 **기능을 적용**할 수 있다.
* 다음 경로의 파일에 자동 구성 대상을 꼭 지정해야 한다.
  * `resources/META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports`
  * 스프링 부트는 해당 파일을 읽어서 자동 구성에 사용한다. 
  * 스프링 부트는 `spring-boot-autoconfigure` 라이브러리를 통해 다양한 자동 구성을 제공한다.
* 자동 구성은 라이브러리를 직접 제공하는 경우가 아니라면 사용할 일이 없다.
  * 다만, 사용하는 라이브러리의 자동 구성을 이해할 수는 있어야 한다.

### 자동 구성의 동작과 원리

`@SpringBootApplication` → `@EnableAutoConfiguration` → `@Import(AutoConfigurationImportSelector.class)`

* `AutoConfigurationImportSelector`가 자동 구성으로 등록된 모든 설정 정보를 확인하고 대상을 판별한다.
  * ImportSelector 구현체를 사용하면 **설정 정보를 동적으로 지정**할 수 있다.
* `@SpringBootApplication` 내부의 `@ComponentScan`은 `@AutoConfiguration`을 제외하는 필터가 적용되어 있다.
  * 자동 구성은 일반 스프링 설정과 라이프 사이클이 다르기 때문에 컴포넌트 스캔의 대상이 되어서는 안된다.
  * 자동 구성 내부에서도 컴포넌트 스캔을 사용해선 안된다.