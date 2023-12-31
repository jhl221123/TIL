# AOP(Aspect Oriented Programming)

**OOP의 한계와 단점을 극복하기 위해 만들어진 관점 지향 프로그래밍**

* 비즈니스 코드(POJO)에 존재하는 엔터프라이즈 기술의 마지막 흔적까지 지워준다.
* 핵심 기능과 부가 기능을 분리해 중복을 제거하고 SRP을 준수하도록 한다.

### AOP 적용 방식

#### 컴파일 시점

* 부가 기능 코드가 핵심 기능 코드 주변에 실제로 붙는다.
* 특별한 컴파일러가 필요하고 복잡해서 잘 사용하지 않는다.(AspectJ 필요)

#### 클래스 로딩 시점

* 클래스 로더에서 .class 파일을 조작한 다음 JVM에 올린다.
* 자바를 실행할 때 특별한 옵션을 통해 클래스 로더 조작기를 지정해야 한다.
    * 번거롭고 운영하기 어려워서 잘 사용하지 않는다.(AspectJ 필요)

#### 런타임 시점

* 자바 실행 후 조작하기 때문에 자바 언어가 제공하는 범위 안에서 부가 기능을 적용한다.
  * 스프링 AOP의 적용 방식
  * 메서드 실행 지점에만 적용 가능하다.
  * 생성자, static, 필드에는 접근하지 못한다.

### AspectJ

**가장 대표적인 AOP 프레임워크**
* 스프링이 제공하는 프록시 방식의 AOP도 AspectJ의 문법을 차용한다.
* 바이트코드를 조작해서 메서드 뿐만 아니라 다양한 곳에 AOP를 적용할 수 있다.

## 스프링 AOP

**스프링은 동적 프록시 방식을 사용**

* 런타임 시점에 프록시 객체를 자동으로 생성한다.
  * 직접 프록시 클래스를 만들지 않아도 된다.
  * 적용하고 싶은 로직만 미리 지정하면 된다.
* 프록시 방식은 메서드에만 적용이 가능하다는 단점이 있다.

### JDK 동적 프록시

**리플렉션 API를 통해 인터페이스 기반으로 프록시를 생성**

* 자바가 제공하는 기술
* 적용할 로직은 InvocationHandler 인터페이스를 구현해서 작성
* 인터페이스가 반드시 필요하다는 단점이 있다.

### CGLIB(Code Generator Library)

**바이트코드 조작을 통해 클래스 상속을 기반으로 프록시를 생성**

* 프록시 생성 기술을 제공하는 라이브러리로 인터페이스 없이 동적으로 프록시 생성 가능
* 상속을 사용하기 때문에 몇가지 제약이 있다.
    * 부모 클래스에 기본 생성자가 꼭 필요하다.(JPA 엔티티에 기본 생성자가 있어야 하는 이유!)
    * 클래스와 메서드 레벨에 final 키워드를 사용하면 안된다.

## ProxyFactory

**인터페이스 유무에 따라 적절한 프록시 생성 방식을 선택**

### JoinPoint

**적용 지점의 메서드, 파라미터 , 인스턴스의 정보 등을 제공**

* 광의의 JoinPoint: 스프링 프레임워크가 관리하는 빈의 모든 메서드
* 협의의 JoinPoint: 호출된 객체의 메서드


### Pointcut

**AOP 적용 위치를 지정**

* 표현식: *[접근제한자]**리턴타입**[패키지&클래스]**메서드이름(파라미터)**[throws 예외]*
* 리턴 타입, 메서드 이름, 파라미터는 필수

### Advice

**부가 기능과 적용 시점을 정의**

* 부가 기능 수행 전후에 실제 타겟을 선택적으로 호출함으로써 적용 시점을 지정할 수 있다.

### Aspect

**여러 개의 Pointcut과 Advice로 구성**

* 어떤 부가 기능을 언제, 어디에 적용할지 정의

### Advisor

**하나의 Pointcut과 하나의 Advice로 구성**

* 스프링 AOP에서만 사용하는 용어로 Aspect를 사용하는 것을 권장한다.