# synchronized

**동기화를 위해 자바에서 제공하는 예약어**

* 임계 영역에 다수의 스레드가 접근할 때, 한 번에 하나의 스레드만 접근할 수 있도록 제한
* 먼저 접근한 스레드는 lock을 얻은 후 작업을 수행하고, 작업을 완료하면 lock을 반환한다.
* 메서드 단위로 사용하거나 원하는 위치에 블록으로 지정해서 사용할 수 있다.

## lock의 공유 범위

4가지 상황에 따라 lock의 공유 범위가 달라진다.

### synchronized method

* 인스턴스 단위로 lock을 공유하며, 인스턴스 자체에 대한 접근을 막는 것은 아니다.
* 동일 인스턴스내에서 synchronized 키워드가 적용된 메서드는 lock을 공유한다.

```java
// 동일한 인스턴스 내에서 synchronized 메서드는 lock을 공유한다.
public synchronized void syncMethodA(){} // lock 소유
public synchronized void syncMethodB(){} // lock 대기

// synchronized 키워드가 없는 일반 메서드는 문제 없이 사용할 수 있다.
public void nonSync(){}
```

### static synchronized method

* 클래스 단위로 lock을 공유하기 때문에 서로 다른 인스턴스가 함께 동기화 된다.
* synchronized method와 lock을 공유하지 않는다.

```java
// 서로 다른 lock을 사용하기 때문에 각각 동기화 과정이 진행된다.
public synchronized void onlySync(){} // lock 소유
public static synchronized void staticSync(){} // lock 소유, 다른 인스턴스에서는 대기
```

### synchronized block

* 인스턴스 단위로 lock을 공유하며, 지정된 block 내부만 동기화한다.
* lock으로 사용할 객체 또는 클래스를 지정할 수 있다.
* lock을 객체로 사용하면 같은 lock을 사용하는 block만 lock을 공유
* lock을 .class형식으로 설정하면 클래스 단위로 lock을 공유

```java
// 서로 다른 lock을 사용하기 때문에 각각 동기화 과정이 진행된다.
public synchronized void syncMethod(){}
public void syncBlock(){
    synchronized (other) {}
}
```

### static synchronized block

* static 메서드 내부에 존재하는 synchronized block
* lock 공유 범위는 앞서 설명한 일반 synchronized 블럭과 동일하게 적용된다.

```java
// lock을 객체로 지정하고 인스턴스 단위로 동기화 수행
public static void staticSyncBlock(){
    synchronized (other) {}
}
```

### 메서드 vs block
* 메서드에 synchronized 키워드를 사용할 경우, static 키워드의 유무로 lock의 공유 범위가 달라진다.
* 블럭에 사용할 경우 static 키워드와 상관없이 lock으로 지정된 것이 객체인지, 클래스인지에 따라 공유 범위가 달라진다.

## StringBuffer vs StringBuilder

* **StringBuffer**: 주요 데이터 처리부분을 synchronized 블록으로 처리해서 스레드에 안전하다.
* **StringBuilder**: 스레드에 안전하지 않지만 성능이 더 좋다.

## synchronized의 단점

* lock을 생성하고 해제하는 작업에서 성능 저하가 발생할 수 있다.
* 잘못된 순서로 해제할 경우 교착 상태에 빠질 수 있다.

동기화 작업이 필요하다면 java.util.concurrent 패키지에서 제공하는 기능을 사용하자.