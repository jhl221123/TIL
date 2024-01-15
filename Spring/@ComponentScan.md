# @ComponentScan

**지정된 패키지 하위의 컴포넌트들을 탐색하고 빈으로 등록**

* 지정한 `basePackage` 하위 패키지를 대상으로 스캔을 수행
    * `basePackage` 를 지정하지 않으면 `@ComponentScan` 이 사용된 클래스의 패키지 부터 수행
* `@Component` 어노테이션을 포함한 클래스를 빈으로 등록
    * `@Configuration` 과  `@Bean` 을 사용한 수동 등록
    * `@Controller` , `@Service` , `@Repository` 을 사용한 자동 등록
* `ConfigurationClassPostProcessor` : `@Configuration` 으로 정의된 빈 중, 가장 먼저 등록되어 다른 빈들을 등록한다.