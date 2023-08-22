# Annotation

'@'기호로 시작하며 메타데이터라고도 한다. 컴파일러에게 정보를 알려주거나, 실행 시점에 별도의 처리가 필요한 경우 사용할 수 있다.

#### 사용을 위한 기본 어노테이션

* @Override: 메서드 재정의를 명시적으로 선언

* @Deprecated: 더이상 사용하지 않음

* @SupressWarnings: 컴파일러 경고를 무시

#### 메타 어노테이션

* @Target: 생성자, 필드, 메서드 등 어떤 것에 적용할지 선언

* @Retention: 어노테이션의 유지 기간을 지정. 컴파일 전, 후 또는 런타임 시점

* @Documented: 지정된 클래스나 메서드 등을 Javadocs 문서에 포함시키는 것을 의미

* @Inherited: 어노테이션을 하위 클래스에서 사용할 수 있도록 지정

### 어노테이션의 추상 메서드

어노테이션을 적용할 때, 값을 지정할 수 있도록 한다.

```java
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface LoginCheck {

    UserLevel userLevel();
    // UserLevel userLevel() default UserLevel.USER;

    enum UserLevel {

        USER, OWNER, RIDER;

        public static UserLevel getEnumLevel(String level) {
            return Enum.valueOf(UserLevel.class, level);
        }
    }
}
```

위 처럼 default 키워드를 사용해서 기본값을 설정할 수 있으며, 아래와 같이 사용 시 값을 설정할 수도 있다.

```java
@LoginCheck(userLevel = UserLevel.OWNER)
```

## 내부 Enum

위 예제처럼 연관된 상수를 논리적으로 묶고 싶은 경우 내부 Enum을 사용할 수 있다.

userLevel() 메서드로 입력받은 UserLevel 값은 getEnumLevel() 메서드의 매개변수로 전달되고 UserLevel 값을 반환한다.

## Annotation을 적용한 AOP

어노테이션을 사용해서 간편하게 포인트컷을 지정할 수 있다.

```java
@Before("@annotation(com.flab.makedel.annotation.LoginCheck) && @annotation(target)")
public void loginCheck(LoginCheck target) throws HttpClientErrorException {
    ...
}
```

LoginCheck가 선언된 메서드를 대상으로 AOP를 적용하며, 어노테이션에 포함된 값을 매개변수로 전달 받을 수 있다.