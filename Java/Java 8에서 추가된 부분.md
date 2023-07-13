# 함수형 인터페이스

Runnable과 같이 하나의 메소드만 선언되어 있는 인터페이스를 함수형 인터페이스라고 한다.

```java
@FunctionalInterface
public interface Runnable {

    public abstract void run();
}
```

* @FunctionalInterface를 사용하면 메소드가 하나가 아닐 경우 에러를 발생시킨다.

* java.util.function 패키지에서 다양한 함수형 인터페이스를 제공한다.

# 람다 표현식

인터페이스에 메소드가 하나만 있을 때 사용할 수 있으며, 익명 클래스 사용 시 가독성이 떨어지는 문제를 해결해준다.

```java
private void runThread() {
    new Thread(() -> System.out.println(Thread.currentThread().getName())).start();
}
```

* '(매개 변수 목록) -> 처리식' 으로 표현하며, 처리식이 한 줄 이상인 경우 중괄호로 묶을 수 있다.

# 스트림

연속된 정보를 처리하기 위해 사용하며, 자료 구조가 아니기 때문에 별도의 저장소는 없다.

처리 과정은 스트림 생성 - 중간 연산 - 종단 연산으로 구분 된다.

```java
List<Integer> list = new ArrayList<>(Arrays.asList(new Integer[] {1, 5, 10, 15}));

list.stream() // 스트림 생성
        .filter(x -> x > 10) // 중간 연산
        .count(); // 종단 연산
```

* 연산 결과는 새 스트림으로 반환되기 때문에 원본 객체에 영향을 주지 않으며, 여러 개의 중간 연산을 연결해서 처리할 수 있다.

* 스트림의 요소는 스트림의 수명 동안 한 번만 방문되기 때문에 동일한 요소에 다시 방문하려면 새 스트림을 생성해야 한다.

# 메소드 참조

더블 콜론(::)으로 표현하며 다음 4가지 종류가 있다.

|종류|예시|
|---|---|
|static 메소드 참조|ContainingClass::staticMethodName|
|특정 객체의 인스턴스 메소드 참조|containingObject::instanceMethodName|
|특정 유형의 임의의 객체에 대한 인스턴스 메소드 참조|ContainingType::methodName|
|생성자 참조|ClassName::new|

# Optional

* null을 보다 간편하게 처리하기 위해 만든 클래스로 null이 아닌 값을 포함하거나, 포함하지 않을 수 있다.

* 주로 "결과 없음"을 표현할 필요가 있을 때 사용하며, null을 사용하면 오류가 발생할 가능성이 있는 메서드의 반환 유형으로 사용한다.

* Optional 변수 자체가 null이 되어서는 안되며, 항상 Optional 인스턴스를 가리켜야 한다.


## Optional 객체를 생성하는 메소드

|Modifier and Type|Method|Description|
|---|---|---|
|static \<T> Optional\<T>|empty()|Returns an empty Optional instance.|
|static \<T> Optional\<T>|of(T value)|Returns an Optional describing the given non-null value.|
|static \<T> Optional\<T>|ofNullable(T value)|Returns an Optional describing the given value, if non-null, otherwise returns an empty Optional.|
|__________________________|____________________||

## 값을 조회하는 메소드

|Type|Method|Description|
|---|---|---|
|T|get()|If a value is present, returns the value, otherwise throws NoSuchElementException.|
|T|orElse(T other)|If a value is present, returns the value, otherwise returns other.|
|T|orElseGet(Supplier<? extends T> supplier)|If a value is present, returns the value, otherwise returns the result produced by the supplying function.|
|\<X extends Throwable>T|orElseThrow(Supplier<? extends X> exceptionSupplier)|If a value is present, returns the value, otherwise returns the result produced by the supplying function.|

# 인터페이스의 기본 메소드

* 자바의 하위 호환성을 위해 지원하는 기능

* 인터페이스에 default 키워드를 사용해서 메소드를 구현할 수 있다.

# java.time

* 날짜, 시간, 및 기간에 대한 기본 API로 이전 버전의 날짜 관련 클래스의 문제를 해결했다.

* 그레고리력을 따르고 모든 클래스는 불변이며 스레드에 안전하다.

* 각 클래스에는 모든 종류의 날짜와 시간을 출력하고 분석할 수 있는 기능이 포함되어 있다. 

# Arrays.parallelSort()

* 처리해야할 데이터가 많을 경우 처리시간을 단축하기 위해 사용한다.

* Fork-Join 프레임워크가 내부적으로 사용되어 여러 쓰레드로 나뉘어 작업이 수행된다.

> Fork-Join이란?<br>
Fork는 여러 개로 나누는 것, Join은 나누어 작업한 결과를 모으는 것으로 작업을 나누어 처리함으로써 소요시간을 단축시킬 수 있다.

# StringJoiner

* 문자열을 기호로 구분하거나 접두사, 접미사를 표현하기 위해 사용한다.