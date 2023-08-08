# 자바 8 람다와 인터페이스 스펙 변화

*빅데이터*

기업들이 빅데이터를 활용해 전략을 수립함에 따라 프로그래머들은 프로그램적으로 빅데이터를 다룰 수 있어야 하게 되었다. 자바 8은 기업 환경 변화와 프로그래머들의 요구에 따라 많은 변화를 맞이했으며, 대표적인 변화로는 함수형 프로그래밍을 지원하는 람다가 있다.

#### 람다까지의 과정

빅데이터 처리를 위한 병렬화 → 병렬화를 위해 컬렉션을 강화 → 좀 더 효율적인 컬렉션 사용을 위해 스트림을 강화 → 스트림을 효율적으로 사용하기 위해 함수형 프로그래밍을 지원 → 함수형 프로그래밍을 위해 람다가 탄생

### 람다

람다는 간단하게 말해서 코드 블럭이라고 할 수 있다. 자바 8 이전에는 메서드를 사용하려면 클래스를 생성하거나 익명 객체를 사용해야만 했다. 이제는 람다가 메서드의 역할을 수행하기 때문에 별도의 생성 없이 메서드(람다)를 변수나, 메서드의 파라미터 등으로 사용할 수 있게 되었다.

#### 메서드 레퍼런스와 생성자 레퍼런스

다음과 같이 람다를 더 간편하게 표현할 수 있다.

```java
// 메서드 레퍼런스
num → Math.sqrt(num)
Math::sqrt

// 생성자 레퍼런스
() → new Instance();
Instance::new
```

### 인터페이스의 변화

람다를 사용하기 위해 함수형 인터페이스가 도입되었고 그에 따라 기존 인터페이스 스펙이 변경되었다.

> **함수형 인터페이스**<br>
추상 메서드를 하나만 가지는 인터페이스로 함수형 인터페이스만 람다로 표현할 수 있다.

기존의 인터페이스는 정적 상수와 추상 메서드만 가질 수 있었다.

```java
public interface BeforeJava8 {
    public static final int constant = 8;

    public abstract void abstractInstanceMethod();
}
```

하지만 함수형 프로그래밍을 지원하기 위해 default 메서드와 static 메서드를 지원하게 되었다.

```java
@FunctionalInterface
public interface AfterJava8 {
    public static final int constant = 8;

    public abstract void abstractInstanceMethod();

    // default method
    public default void concreteInstanceMethod();

    // static method
    public static void concreteStaticMethod();
}
```

default 메서드와 static 메서드를 사용해 호환성을 유지하면서 기존 인터페이스를 강화할 수 있게 되었다.