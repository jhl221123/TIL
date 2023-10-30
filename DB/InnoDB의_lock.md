# InnoDB의 lock

**트랜잭션의 ACID 원칙과 동시성을 최대한 보장하기 위해 다양한 lock을 사용**

## Row-level lock

**테이블의 row 단위로 걸리는 가장 기본적인 lock**

* 크게 shared lock(S lock)과 exclusive lock(X lock)으로 구분된다.

### S lock(공유락)

* 조회에 대한 lock으로 `SELECT FOR SHARE` 등 일부 `SHARE` 쿼리에 적용
  * 일반적인 `SELECT` 쿼리는 lock을 사용하지 않는다.
* 여러 트랜잭션이 동시에 S lock을 걸 수 있다.
  * 동시에 하나의 row 조회 가능
* S lock이 걸려있는 row에 다른 트랜잭션이 X lock을 걸 수 없다.
  * 다른 트랜잭션에서 수정, 삭제 불가능

### X lock(배타락)

* 쓰기에 대한 lock으로 `SELECT FOR UPDATE`, `UPDATE`, `DELETE` 등의 쿼리에 적용
* X lock이 걸려있는 row는 다른 트랜잭션이 S lock과 X lock, 모두 걸 수 없다.
  * 다른 트랜잭션에서 조회, 수정, 삭제 모두 불가능

## Record lock

**DB의 index record에 걸리는 lock**

* row-level lock과 마찬가지로 S lock과 X lock을 사용한다.
* `` SELECT c1 FROM t WHERE c1 = 10 FOR UPDATE;``
  *  다른 트랜잭션이 t.c1 값이 10인 행을 삽입, 수정, 삭제하지 못한다.
* 인덱스 없이 정의된 테이블의 경우, hidden clustered index를 생성해서 사용한다.

## Gap lock

**DB index record의 gap에 걸리는 lock**

* `SELECT c1 FROM t WHERE c1 BETWEEN 10 and 20 FOR UPDATE;`
  * t.c1의 값이 10과 20 사이인 gap에 lock이 걸린다.
  * c1이 13, 17만 존재한다면 10 <= id <= 12, 14 <= id <= 16, 18 <= id <= 20이 gap에 해당한다.
  * 다른 트랜잭션이 t.c1 = 15인 row를 삽입하려고 하면 gap lock 으로 인해 수행 불가능하다.
* 일부 트랜잭션 격리수준에만 사용
  * 동시성과 정합성에 대한 트레이드 오프가 존재

## Next-Key Locks

**Record lock과 Gap lock의 조합**

* Repeatable read 격리수준에 적용되는 방식
  * Phantom read를 방지하기 위해 사용

## Insert Intention Locks

**동일한 갭에서 서로 다른 위치에 삽입하기 위해 사용하는 lock**

* Gap lock의 한 종류로 서로 기다릴 필요가 없다는 의도를 가진다.
* 갭의 범위가 10~20, 서로 다른 트랜잭션이 14와 15에 삽입하는 경우
  * 14를 삽입할 때 Gap lock을 걸면 14가 삽입된 후, 15가 삽입된다.
  * Insert Intention Lock을 걸면 기다리지 않고 바로 15 삽입 가능