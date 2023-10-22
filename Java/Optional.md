# Optional

**null을 간편하게 처리할 수 있도록 지원하는 클래스**

* null 또는 null이 아닌 값을 포함할 수 있다.
* `결과 없음`을 표현할 필요가 있을 때 사용한다.
* null로 인해 오류가 발생할 가능성이 있는 메서드의 반환 유형으로 사용한다.
* Optional 변수 자체가 null이 되어서는 안되며, 항상 Optional 인스턴스를 가리켜야 한다.

## 생성 메서드

**생성자로 직접 생성하지 않고, static 메서드를 통해 전달받는다.**

* **empty()**: 비어있는 Optional 객체 반환
* **of(T value)**: Optional 내부가 null 이어서는 안된다.
* **ofNullable(T value)**: 결과가 null 이라면 비어있는 Optional 객체 반환

## 조회 메서드

* **get()**: 값이 없다면 NoSuchElementException 발생(값이 있는 경우만 사용)
* **orElse(T other)**: 값이 없다면 지정한 other 반환
* **orElseGet(Supplier<? extends T> supplier)**: 값이 없다면 지정한 메서드 조각을 반환
* **orElseThrow(Supplier<? extends X> exceptionSupplier)**: 값이 없다면 지정한 메서드 조각을 반환.
  * 이때 메서드 조각은 Throwable 하위 타입을 반환해야 한다.

## orElse vs orElseGet

**지연처리 할 수 없다 vs 있다**

* **orElse**: 매개변수로 값을 전달받는다.
* **orElseGet** 메서드는 매개변수로 Supplier 타입 즉, 메서드 자체를 전달받는다.

### 값 자체를 전달할 경우

Optional과 관계없이 문제가 없다.

```java
String str = null;

String targetA = Optional.ofNullable(str).orElse("isNull");
String targetB = Optional.ofNullable(str).orElseGet(() -> "isNull");

System.out.println("targetA = " + targetA); //isNull
System.out.println("targetB = " + targetB); //isNull
```

### 메서드를 호출하는 경우

Optional 내부가 null이라면, 문제가 없지만 값이 존재할 때 서로 다르게 적용된다.

```java
String str = null;

String targetA = Optional.ofNullable(str).orElse(tryMethod()); //Oops!!
String targetB = Optional.ofNullable(str).orElseGet(() -> tryMethod()); //Oops!!

            ...

private String tryMethod() {
    System.out.println("Oops!!");
    return "isNull";
}
```

* Optional 내부가 null이라면 tryMethod() 메서드가 각각 호출된다.
* Optional에 값이 존재한다면 orElseGet에 전달된 메서드만 호출되지 않는다.
  * orElse는 값을 전달 받기 때문에 Optional 여부와 관계없이 메서드가 호출되어 값을 전달해야만 한다.
  * orElseGet은 메서드 조각을 전달받기 때문에 지연처리가 가능하다.
* 따라서 Optional 내부가 null이 아닐 때, 실행되면 안되는 로직은 orElseGet을 사용하는 것이 안전하다.