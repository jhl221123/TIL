# SoC(Separation of Concerns)

애플리케이션의 변경이나 발전은 보통 한가지 관심에 집중적으로 일어난다.

만약 여러 관심사가 혼재되어 있다면 변경되는 부분을 일일히 찾아야하고 변경 후에도 다른 관심사에 영향을 미치지 않았는지 확인해야한다. 이런 부담을 줄이기 위해 관심사를 분리하는 것이 중요하다.

### 상속을 사용해서 관심사를 분리

상위 타입에서 관심사가 다른 부분을 추상 메서드로 만들고 하위 타입으로 관심사를 분리할 수 있다. 하지만 다중 상속 불가, 상위 타입과의 강한 연관과 같이 상속의 문제를 그대로 떠안게 된다.

### 클래스 분리를 통해 관심사를 분리

관심사가 다른 클래스를 분리함으로써 간단하게 해결할 수 있지만 구체화에 의존하게 되는 문제가 생긴다. 인터페이스를 도입해도 여전히 구체클래스에 의존하기 때문에 관계설정을 담당하는 제 3자가 필요하다.

# DI(Dependency Injection)

의존관계 주입이라고 하며, 스스로 의존성을 결정하지 않고 외부에서 전달받는 것을 의미한다. 이때 주의해야 할 점은 단순히 외부에서 주입받는다고 DI가 아니다. DI는 구현클래스를 동적으로 결정하는 것을 내포하기 때문에 이미 고정된 구현체를 주입받는 것을 DI라고 혼동해서는 안된다.

## 의존 관계 주입의 조건

1. 클래스 코드에는 런타임 의존관계가 드러나지 않아야 한다.(인터페이스에 의존)

2. 제 3자에 의해 런타임 의존관계가 결정된다.

3. 결정된 의존관계에 따라 레퍼런스를 외부에서 주입 받는다.

스프링은 컴포넌트와 설계도로 구성되며, 여기서 설계도는 설정정보와 DI 컨테이너로 구성된다.

## DI 컨테이너

관계설정의 역할을 담당하는 제 3자로 클래스 사이의 관계가 아닌 객체사이의 관계를 결정한다. DI 컨테이너를 사용해 의존관계를 설정하는 관심사까지 분리했기 때문에 높은 응집도와 낮은 결합도를 가질 수 있게 된다. 그 결과로 변경의 파급효과를 줄이고, 확장 방법이 다양해진다.

#### IoC(제어의 역전)

소프트웨어 상에서 제어 흐름이 역전되는 것을 나타내는 용어로 DI 역시 IoC의 한 개념이기 때문에 IoC 컨테이너라고 부르기도 한다. 하지만 스프링은 DI라는 용어를 사용해서 좀 더 의도를 명확하게 나타낸다.

## 의존관계 검색(DL)

생성자나 메서드의 파라미터로 외부에서 주입받는 것이 아니라, 컨테이너를 조합으로 사용해 직접 컨테이너에서 필요한 객체를 가져오는 것이다.

### 주입과 검색의 차이

필요한 객체의 생성과 관계설정은 컨테이너에게 맡기지만 객체를 직접 가져오는 것에서 의존관계 주입과 차이가 있다. 검색을 사용하려면 스프링 컨테이너에 의존해야 하기 때문에 의존관계를 주입받는 것이 더 깔끔하다. 하지만 main 메서드나 서블릿처럼 주입받지 못하는 경우에는 의존관계 검색을 사용해야만 한다.

한 가지 더 차이가 있는데 검색을 사용한 클래스는 꼭 스프링 빈일 필요는 없다. 필요에 따라 생성해서 사용하면 된다. 하지만 주입의 경우 스프링 컨테이너가 주입해줘야 하기 때문에 반드시 스프링 컨테이너가 관리하는 빈이어야 한다.

다시 말해 의존관계를 주입받기 위해서는 스프링 컨테이너가 관리하는 빈이 되어야만 한다.

#### 요약

DI 컨테이너를 사용해서 제어흐름이 역전되면, 스프링이 관리하는 빈들은 '무엇'보다 '어떻게'에 집중할 수 있게된다. 그 결과로 변경의 파급효과를 줄이고 확장에 있어 자유로워진다.

## 싱글톤

DI 컨테이너는 싱글톤 패턴을 사용하지 않고 빈의 싱글톤을 보장한다.

#### 싱글톤 패턴의 단점

1. private 생성자를 사용해 상속이 불가능

2. 자유롭게 생성하지 못해 테스트가 어렵다.

3. 서버 환경에서 확실하게 싱글톤을 보장하지 못한다.

4. 스태틱 메서드를 사용하기 때문에 전역상태 되기 쉬우며, 이는 객체지향적 설계가 아니다.

### 싱글톤 레지스트리

스프링이 직접 싱글톤 형태의 객체를 만들고 관리하는 기능으로 싱글톤 패턴과 그 방식이 다르다. 스프링은 CGLIB을 사용해서 컨테이너에 빈이 존재하지 않으면 객체를 생성하고, 이미 존재한다면 해당 빈을 반환하는 방식으로 싱글톤을 보장한다. 따라서 스프링이 관리하는 빈들은 싱글톤 객체이지만 평범한 자바 객체처럼 사용할 수 있다.