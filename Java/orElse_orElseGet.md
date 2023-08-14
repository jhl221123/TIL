# Optional의 orElse() vs orElseGet()

orElse() 메서드는 매개변수로 값을 전달받고, orElseGet() 메서드는 매개변수로 Supplier 타입 즉, 메서드 자체를 전달받는다.

|Type|Method|
|---|---|
|T|orElse(T other)|
|T|orElseGet(Supplier<? extends T> supplier)|

이 차이는 단순해 보이지만 실제 코드상에서 실수하기 쉬운 부분이다.

아래 예시를 보자.

```java
String str = null;

String targetA = Optional.ofNullable(str).orElse("isNull");
String targetB = Optional.ofNullable(str).orElseGet(() -> "isNull");

System.out.println("targetA = " + targetA);
System.out.println("targetB = " + targetB);
```

값 자체를 전달할 경우에는 문제가 없다. 예상대로 둘 다 "isNull"이 출력된다.  그럼 아래코드는 어떨까?

```java
String str = null;

String targetA = Optional.ofNullable(str).orElse(tryMethod());
String targetB = Optional.ofNullable(str).orElseGet(() -> tryMethod());

            ...

private String tryMethod() {
    System.out.println("Oops!!");
    return "isNull";
}
```

tryMethod() 메서드가 두 번 호출되며, "Oops!!"가 두 번 출력되는 것을 확인할 수 있다.

그럼 뭐가 문제일까?

문제는 Optional에 포함된 값이 null이 아닐 경우 발생한다. 위 코드에서 str에 null이 아닌 문자열을 대입한다면, 예상과 다르게 "Oops!!"가 한 번 출력되는 것을 확인할 수 있다. str이 null이 아닌데 어떻게 tryMethod() 메서드가 호출될까?

이 부분이 매개변수로 값을 전달 받느냐, 메서드 자체를 전달 받느냐의 차이다. orElseGet() 메서드는 메서드 자체를 매개변수로 전달받기 때문에 Optional에 포함된 값이 null이 아니라면 tryMethod() 메서드는 호출되지 않는다. 단지 메서드 자체가 전달될 뿐이다.

하지만 orElse() 메서드는 값을 매개변수로 전달받기 때문에 Optional에 포함된 값과 상관없이 tryMethod() 메서드가 호출된다. 매개변수로 값을 전달하려면 tryMethod() 메서드가 반환하는 값을 얻어야 하기 때문이다.

이로 인해 Optional에 포함된 값이 null이 아닌 경우, 실행되면 안되는 로직이 실행될 수 있으며 심각한 문제로 이어질 수 있다. 따라서 단순히 값을 전달하는 것이 아니라면 orElseGet() 메서드를 사용하는 것이 안전하다.