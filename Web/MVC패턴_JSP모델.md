# MVC 패턴

역할에 따라 모델, 뷰, 컨트롤러로 나누며 웹 애플리케이션은 보통 MVC 패턴을 사용한다.

* 컨트롤러: 클라이언트의 요청 처리와 흐름 제어를 담당한다.

* 모델: 비즈니스 영역의 로직을 처리한다.

* 뷰: 비즈니스 영역에 대한 결과 화면을 담당한다.

### 왜 MVC 패턴을 사용할까?

#### 너무 많은 역할
하나의 서블릿이나 JSP만으로 비즈니스 로직과 뷰 렌더링까지 모두 처리하는 것은 너무 많은 역할을 가진다. 

#### 변경의 라이프 사이클
비즈니스 로직과 화면과 관련된 부분은 보통 변경의 라이프 사이클이 다르며, 대부분 서로에게 영향을 주지 않는다. 그럼에도 변경이 발생하면 모든 코드가 같이 있는 파일을 수정해야 하기 때문에 유지보수가 어려워진다.  

#### 기능 특화
JSP와 같은 템플릿 엔진은 화면을 렌더링 하는데 최적화 되어 있기 때문에 이 부분의 업무만 담당하는 것이 가장 효과적이다.

#### MVC 패턴의 핵심

* 비즈니스 로직을 처리하는 모델, 결과 화면을 보여주는 뷰를 분리한다.

* 애리케이션의 흐름 제어나 사용자의 처리 요청은 컨트롤러에 집중된다.

역할에 따라 모델과 뷰를 분리했기 때문에 모델 내부 로직이 변경되어도 뷰는 영향을 받지 않고, 모델의 내부 구현 로직에 상관없이 뷰를 변경할 수 있다.

컨트롤러는 요청에 따라 알맞은 모델과 뷰를 선택함으로써 전체 흐름을 제어한다. 또, 단일 진입점 통해서 요청을 처리하기 때문에 애플리케이션 전체에 적용되는 기능을 처리할 수도 있다.

애플리케이션의 흐름 제어나 보안 설정이 변경되면 컨트롤러만 변경하면 되고, 결과 화면에 변경사항이 생길 경우 뷰를 추가하거나 수정하면 된다.

MVC 패턴을 사용함으로써 유지보수 작업이 쉬워지고 애플리케이션을 쉽게 확장할 수 있게 된다.

# JSP

서블릿을 사용해 동적으로 뷰 화면을 만들 수 있지만, HTML과 자바 코드가 섞여 매우 지저분해진다.

```java
PrintWriter w = response.getWriter();
 w.write("<html>");
 w.write("<head>");
 w.write(" <meta charset=\"UTF-8\">");
 w.write(" <title>Title</title>");
 w.write("</head>");
 w.write("<body>");
 w.write("<p>" + user.getName() + "</p>");
 w.write("</body>");
 w.write("</html>");
```

JSP는 위처럼 자바 코드로 HTML을 작성하는 것이 아니라 HTML 형식에 자바 코드를 사용해서 작성하고, 서버 내부에서 서블릿으로 변환된다.

JSP 웹 애플리케이션의 구조는 처리 범위에 따라 모델 1과 모델 2로 나뉜다.

## 모델 1

웹 브라우저의 요청을 JSP가 직접 처리한다. 즉, 비즈니스 로직과 화면 출력 모두 처리한다.

![Alt text](<이미지/JSP 모델1 구조.png>)

모델 1 구조는 **비즈니스 로직과 화면 출력 코드가 함께 존재하는 단점**이 있다.

## 모델 2

모든 요청은 하나의 서블릿에서 처리되며, 비즈니스 로직과 화면 출력 코드를 분리하는 구조로 MVC 패턴과 거의 동일하다.

|MVC 패턴|모델 2|
|---|---|
|컨트롤러|서블릿|
|모델|로직 처리 클래스, 자바빈|
|뷰|JSP|
|사용자|웹 브라우저, 그 외 다양한 기기|

모델 2의 동작 방식은 아래와 같다.

![Alt text](<이미지/JSP 모델2 구조.png>)

### 서블릿

MVC 패턴의 컨트롤러 역할이며, 웹 애플리케이션의 전체적인 흐름을 제어한다.

비즈니스 로직의 처리는 모델에서 수행되기 때문에 서블릿은 모델이 내부적으로 어떻게 로직을 처리하는지 알 필요 없다. 단지 요청에 따라 알맞게 모델을 호출한 후 결과를 받고, 결과로 보여줄 JSP를 선택한 후 모델로부터 받은 결과를 전달하면 된다.

서블릿을 초기화 할 때, 설정 파일을 이용해 Handler 객체를 미리 생성해둔다.

### 로직 처리 클래스

MVC 패턴의 모델 역할이며, 비즈니스 로직으로 요청을 처리하는 부분이다.

서블릿(MVC 컨트롤러)이 웹 브라우저의 요청을 분석해서 알맞은 모델을 호출하면 모델의 기능이 시작된다. 비즈니스 로직은 서비스 클래스나 DAO를 사용해서 처리하며, DTO 등을 사용해서 결과를 반환한다.

### JSP

MVC 패턴의 뷰 역할로 모델 1 구조와 달리 비즈니스 로직과 관련된 코드가 없다.

요청한 결과를 보여주는 역할과 더불어 웹 브라우저의 요청을 서블릿(MVC 컨트롤러)에 전달하는 역할도 수행한다. 예를 들어 글을 작성하는 양식을 결과화면으로 응답했을 때, 해당 글을 서버로 전송하는 버튼 등으로 요청을 전달할 수 있다.

## 모델 1과 모델 2의 장단점
|모델|||
|---|---|---|
|모델1|장점|간단한 경우 빠르게 구현가능하다.<br>기능과 JSP가 직관적으로 연결된다.|
||단점|비즈니스 로직과 뷰 코드가 혼합되어 코드가 복잡하고 유지보수가 힘들어진다.|
|모델2|장점|비즈니스 로직과 뷰가 분리되어있어 유지보수하기 편하고 확장이 용이하다.<br>단일 지점에서 요청을 받기 때문에 공통 기능 처리가 가능하다.
||단점|각각의 역할에 맞게 코드를 설계하고 작성해야 하기 때문에 작업량이 많다.|