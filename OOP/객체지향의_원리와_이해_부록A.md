# 스프링 MVC

스프링 MVC는 URL 기반으로 이뤄지는 클라이언트의 요청을 편리하게 처리할 수 있도록 지원한다.

## 스프링 MVC - Controller

스프링은 모든 요청을 단일 지점으로 모은 후, 요청 URL에 맞는 핸들러를 호출한다.

전체적인 흐름은 다음과 같다.

![Alt text](<이미지/스프링 MVC 흐름.png>)

1. 클라이언트의 요청

2. request에서 요청 URL 조회 후, 정보에 맞는 Handler 반환

3. 해당 Handler를 지원하는 HandlerAdapter를 확인

4. 요청에 맞는 Adapter 반환

5. Adapter를 통해 Handler 호출

6. 전달 받은 ModelAndView로 View 생성 및 반환

7. View 객체의 render() 메서드 호출

8. 결과 화면을 응답

### DispatcherServlet

* 전체적인 흐름을 제어하며, 요청 정보에 맞는 Handler를 호출하고 ViewResolver로 결과를 전달한다.

* 애플리케이션 내에 있는 HandlerAdapter 정보를 초기화 시점에 미리 등록해둔다.

```java
private void initHandlerAdapters(ApplicationContext context) {
		this.handlerAdapters = null;

		if (this.detectAllHandlerAdapters) {
			// Find all HandlerAdapters in the ApplicationContext
		}
	}
```

### HandlerAdapter

* 각 핸들러가 반환하는 정보를 공통된 결과인 **ModelAndView로 변환**해서  반환한다.

* supports() 메서드로 해당 Handler를 지원하는지 확인한 후, handle() 메서드로 Handler를 호출한다.

```java
public interface HandlerAdapter {

	boolean supports(Object handler);

	@Nullable
	ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception;
}
```

### Handler(Controller)

* DispatcherServlet에서 직접 호출하는 것이 아니라 어댑터를 통해 어떤것도 호출할 수 있기 때문에 상위 개념인 핸들러로 표현한다.

* 호출된 핸들러는 요청에 맞는 서비스 로직을 호출하고 ModelAndView 또는 ViewName을 반환한다.

### ViewResolver

* DispatcherServlet으로부터 전달받은 ModelAndView를 사용해서 View 객체를 반환한다.

* BeanNameViewResolver, InternalResourceViewResolver(JSP), ThymeleafViewResolver 등이 있으며, View의 논리이름을 사용해서 호출된다.


#### @Controller

* 스프링 MVC에서 어노테이션 기반 컨트롤러로 인식한다.

* 내부에 @Component 어노테이션이 있어서 컴포넌트 스캔의 대상이 되고, 스프링이 자동으로 스프링 빈으로 등록한다.

> @Controller가 @Component를 포함하는 것처럼 어노테이션을 묶어서 사용할 수 있게 지원하는 기능은 자바에서 제공하는 것이 아니라 스프링에서 제공하는 기능이다.

#### @RequestMapping

* 요청 URL을 매핑하며, 요청 시 해당 URL로 지정된 메서드가 호출된다. 

* @GetMapping, @PostMapping 등 HTTP Method에 따라 구분해서 처리할 수 있다.

#### @PathVariable

* URL 경로에서 변수를 추출하여 컨트롤러 메서드의 파라미터로 전달하는 기능을 제공한다.

* 동적으로 편리하게 값을 추출할 수 있다.

#### @ResponseBody

* HTTP Method의 Body로 직접 응답을 전송한다.

* View를 거치지 않고 데이터를 클라이언트에게 바로 제공할 수 있다.

#### @ModelAttribute

* 입력받은 데이터를 자바 객체에 자동으로 주입해준다.

#### @SessionAttribute

* 세션에 값을 저장하거나 가져올 수 있다.

* 클래스 레벨에 사용하면 @ModelAttribute로도 저장할 수 있다.

#### @Valid, BindingResult

* @Valid는 지정한 조건에 맞는지 검증한다.

* 검증 결과 오류가 있다면 BindingResult에 주입된다.

### PRG 패턴

POST 요청 후 결과 화면을 받았을 때, URL은 변함 없이 그대로다. 여기서 새로고침을 하면 동일한 요청을 다시 보내게 되는데, 결제 도중 이런 문제가 발생하면 치명적이다. POST 요청 후 GET 요청으로 redirect하면 문제를 해결할 수 있다. 이런 패턴을 POST-redirect-GET(PRG)이라고 한다.

## 스프링 MVC - Model

비즈니스 로직을 처리하는 부분을 담당하며 서비스 계층이 이에 해당한다. DAO, DTO를 사용해서 DB에 접근해 데이터를 조회하거나 저장한다.

간혹 특별한 로직 없이 Repository 계층을 위임하기만 하는 경우도 있지만, 확장성과 유연성을 고려해서 항상 서비스 계층을 두는 것이 유리하다.

## 스프링 MVC - View

서비스 계층에서 반환된 결과를 ModelAndView 형태로 전달받는다. ModelAndView가 가지고 있는 View 논리 이름으로 ViewResolver를 찾고 View를 생성해서 결과를 응답한다.