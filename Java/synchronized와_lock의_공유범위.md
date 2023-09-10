# synchronized 키워드와 lock의 공유 범위

다음 4가지 상황에 따라 lock의 공유 범위가 달라진다.

## synchronized method

* 인스턴스 단위로 lock을 공유하며, 인스턴스 자체에 대한 접근을 막는 것은 아니다.
* 메서드가 시작될 때부터 종료될 때까지 동기화된다.
* 동일 인스턴스내에서 synchronized 키워드가 적용된 곳은 lock을 공유하기 때문에 서로 다른 메서드가 lock을 공유하게 된다.

```java
// 동일한 인스턴스 내에서 synchronized 메서드는 lock을 공유한다.
public synchronized void syncMethodA(){} // lock 소유
public synchronized void syncMethodB(){} // lock 대기

// synchronized 키워드가 없는 일반 메서드는 문제 없이 사용할 수 있다.
public void nonSync(){}
```

## static synchronized method

* 클래스 단위로 lock을 공유하며, 서로 다른 인스턴스가 함께 동기화 된다.
* 메서드가 시작될 때부터 종료될 때까지 동기화된다.
* synchronized 키워드만 있는 경우와 lock을 공유하지 않는다.

```java
// 서로 다른 lock을 사용하기 때문에 각각 동기화 과정이 진행된다.
public synchronized void onlySync(){} // lock 소유
public static synchronized void staticSync(){} // lock 소유, 다른 인스턴스는 대기
```

## synchronized block

* 인스턴스 단위로 lock을 공유하며, 지정된 block 내부만 동기화한다.
* lock으로 사용할 객체 또는 클래스를 지정할 수 있다.
* lock을 객체로 사용하면 인스턴스 단위로 lock이 걸리고, .class형식으로 설정하면 클래스 단위로 lock을 건다.

```java
// 서로 다른 lock을 사용하기 때문에 각각 동기화 과정이 진행된다.
public synchronized void syncMethod(){}
public void syncBlock(){
    synchronized (other) {}
}
```

## static synchronized block

* 동기화 범위를 지정하고, 사용할 lock을 지정할 수 있다.
* static 메서드 내부의 블럭이지만 lock을 객체로 지정하고 인스턴스 단위로 관리할 수 있다.

```java
// lock을 객체로 지정하고 인스턴스 단위로 동기화 수행
public static void staticSyncBlock(){
    synchronized (other) {}
}
```

#### 정리

* 메서드에 synchronized 키워드를 사용할 경우, static 키워드의 유무로 lock의 공유 범위가 달라진다.
* 블럭에 사용할 경우 static 키워드와 상관없이 lock으로 지정된 것이 객체인지, 클래스인지에 따라 공유 범위가 달라진다.