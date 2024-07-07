# Transactional Outbox Pattern

**분산 시스템에서 데이터를 안전하게 전달하기 위해 사용하는 패턴**

* DB 트랜잭션을 활용해서 DB 작업과 메시지 생성을 원자적으로 처리한다.
* at least once delivery 전략으로 데이터를 전달한다.
  * 데이터를 수신하는 쪽에서 멱등 처리해야 한다.

## 분산 시스템에서 발생할 수 있는 문제

### 발행되어야 하는 메시지가 발행되지 않는 경우

* 서비스 계층에서 작업이 성공적으로 수행되었지만, 메시지 발행 도중 예외가 발생할 수 있다.

#### Controller

```java
@RestController
public class MarketController {

    private final MarketService service;
    private final IMessagePublisher publisher;

    ...

    @PostMapping(...)
    public void registerProduct(@RequestBody RegisterProduct command) {
        Product product = service.registerProduct(command);
        var message = ProductRegistered.from(product);
        publisher.publish(message);
    }
}
```

#### Service

```java
public class MarketService {

    private final IMarketRepository repository;

    ...

    @Transactional
    public Product registerProduct(RegisterProduct command) {
        validate(command);
        var product = Product.create(command);
        repository.save(product);
        return product;
    }
}
```

### 발행되지 않아야 하는 메시지가 발행되는 경우

* 위 문제를 해결하기 위해 트랜잭션 내부에서 메시지를 발행할 수 있다.
* 하지만 실제 커밋이 일어나기 전에 메시지가 발행되기 때문에 아래 두 가지 문제가 발생한다.
  * 메시지가 이미 발행되었기 때문에 DB작업(CUD)에 대한 예외가 발생하더라도 되돌릴 수 없다.
  * 작업에 성공하더라도 메시지 발행과 실제 커밋 시점의 간격 만큼 정합성을 보장하지 못한다.
    * DB 처리 지연 등으로 인해 해당 간격이 커질 수 있다.

#### Controller

```java
@RestController
public class MarketController {

    private final MarketService service;

    ...

    @PostMapping(...)
    public void registerProduct(@RequestBody RegisterProduct command) {
        service.registerProduct(command);
    }
}
```

#### Service

```java
public class MarketService {

    private final IMarketRepository repository;
    private final IMessagePublisher publisher;

    ...

    @Transactional
    public void registerProduct(RegisterProduct command) {
        validate(command);
        var product = Product.create(command);
        repository.save(product);
        var message = ProductRegistered.from(product);
        publisher.publish(message);
    }
}
```

## 해결 방안

### 보상 프로세스

* 가장 간단한 아이디어지만, 완벽한 해결책이 될 수 없다.
  * 비효율적인 자원 사용
  * 스케줄링 주기 동안 정합성을 보장하지 못한다.

### Transactional Outbox Pattern 도입

* DB 트랜잭션을 활용해서 DB 작업과 메시지 생성을 원자적으로 처리한다.

```java
public class MarketService {

    private final IMarketRepository repository;
    private final IMarketMessageOutbox outbox;

    ...

    @Transactional
    public void registerProduct(RegisterProduct command) {
        validate(command);
        var product = Product.create(command);
        repository.save(product);
        var message = ProductRegistered.from(product);
        outbox.save(message);
    }
}
```

* 저장된 메시지는 polling해서 발행한다.
* 이 과정에서 동일한 메시지가 중복해서 발행될 수 있기 때문에 멱등성을 보장해야 한다.

```java
public class MessagePublishingJob {

    private final IMarketMessageOutbox outbox;
    private final IMessagePublisher publisher;

    ...

    @Scheduled(fixedRate = 1000)
    public void publishMessages() {
        var messages = outbox.read(10);
        publisher.publish(messages); // 10개 중 5개 전송 -> 6번째 예외 발생 -> 이후 앞서 발행한 5개는 중복해서 발행된다.
        outbox.delete(messages);
    }
}
```