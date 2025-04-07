# ConcurrentHashMap

**스레드에 안전한 Map 자료구조**

* CAS를 통해 연산의 원자성, `volatile` 키워드를 통해 메모리 가시성을 확보한다.
* 스레드 접근 제한을 최소화하는 동기화 방식을 사용한다.

### CAS 방식의 원자적 연산

* CAS(Compare and Swap)는 연산의 원자성을 보장하기 위한 알고리즘이다.
* 현재 메모리의 값이 기대하는 값과 다르다면 작업을 수행하지 않는다.

#### `i++;`를 통한 원자적 연산의 예시
  1. 변수 i의 값을 메모리에서 읽어 캐시에 저장한다.
  2. 캐시의 값에 1을 더한다.
  3. 더한 값을 캐시에 저장한다.
  4. 캐시에 저장된 연산 결과를 메모리에 저장한다.

* 멀티 스레드 환경에서 스레드A가 `4번`을 수행하기 전에 스레드B가 `1번`을 수행하면 연산의 무결성이 깨진다.
* `1~4번`을 하나의 연산으로 만들어 원자처럼 더이상 분리하지 못하는 것을 연산의 원자성이라고 한다.
* 연산의 원자성만으로는 동기화를 보장할 수 없다.

## putVal() 메서드의 내부 구조

* 조회 또는 빈 버킷에 값을 저장할 때는 CAS 연산과 volatile을 활용해 lock 사용을 최소화한다.
* 이미 값이 존재하는 버킷을 처리할 때만 synchronized를 사용한다.
  * 버킷에 값이 존재하는 작업에는 수정 작업과 해시 충돌이 발생한 저장 작업이 있다. 

```java
final V putVal(K key, V value, boolean onlyIfAbsent) {
        if (key == null || value == null) throw new NullPointerException(); // 1
        int hash = spread(key.hashCode());
        int binCount = 0;
```
1. key 또는 value가 null일 경우 NullPointerException이 발생(ConcurrentHashMap은 null을 허용하지 않는다.)

```java        
        for (Node<K,V>[] tab = table;;) {// 2
            Node<K,V> f; int n, i, fh; K fk; V fv;
            if (tab == null || (n = tab.length) == 0)// 3
                tab = initTable();
            else if ((f = tabAt(tab, i = (n - 1) & hash)) == null) {// 4
                if (casTabAt(tab, i, null, new Node<K,V>(hash, key, value)))
                    break;                  
            }
            else if ((fh = f.hash) == MOVED)
                tab = helpTransfer(tab, f);// 5
            else if (onlyIfAbsent // 6
                     && fh == hash
                     && ((fk = f.key) == key || (fk != null && key.equals(fk)))
                     && (fv = f.val) != null)
                return fv;
```
2. 저장 혹은 수정 작업이 수행되기 전까지 반복한다.
3. table은 버킷 배열로, 값을 처음 저장하는 시점에 초기화한다.(사용할 때 초기화)
4. 현재 해시값에 해당하는 노드가 존재하지 않는다면(버킷이 비어있다면) casTabAt() 메서드를 호출한다.
   * 내부적으로 Unsafe 클래스의 인스턴스로 compareAndSetObject() 메서드를 호출하고 하드웨어 수준에서 원자적 연산이 수행된다.
5. 버킷을 리사이징 해야할 경우, helpTransfer() 메서드를 호출(내부적으로 정적 중첩 클래스인 ForwardingNode를 활용)
6. key에 해당하는 value를 변경하지 않고 반환. putIfAbsent(), add(), addAll() 메서드에서 적용될 수 있다.

```java                
            else {
                V oldVal = null;
                synchronized (f) {// 7
                    if (tabAt(tab, i) == f) {
                        if (fh >= 0) {
                            binCount = 1;
                            for (Node<K,V> e = f;; ++binCount) {// 8
                                K ek;
                                if (e.hash == hash &&
                                    ((ek = e.key) == key ||
                                     (ek != null && key.equals(ek)))) {// 9
                                    oldVal = e.val;
                                    if (!onlyIfAbsent)
                                        e.val = value;
                                    break;
                                }
                                Node<K,V> pred = e;
                                if ((e = e.next) == null) { // 10
                                    pred.next = new Node<K,V>(hash, key, value);
                                    break;
                                }
                            }
                        }
                            ...
                    }
                }
                if (binCount != 0) {
                    if (binCount >= TREEIFY_THRESHOLD)
                        treeifyBin(tab, i);
                    if (oldVal != null)
                        return oldVal; //11
                    break;
                }
            }
        }
        addCount(1L, binCount);
        return null;
    }
```

7. 현재 해시값을 가진 버킷이 이미 존재하는 경우, synchronized 처리한다.
8. 해당 버킷에 존재하는 노드를 순회하면서 입력된 key와 value가 수정대상인지 저장대상인지 판별한다.
    * 버킷 내부에 동일한 key를 가진 노드가 있다면 수정, 없다면 저장
9. 버킷에 존재하는 노드 중, 현재 key와 일치하는 것을 찾으면 이전 value를 oldVal에 저장하고, onlyIfAbsent에 따라 value를 수정한다.
    * 수정할 필요가 없다면, oldVal를 통해 현재 값을 보여준다.
10. 버킷에 현재 key와 일치하는 노드가 없다면, 새로운 노드를 생성하고 저장한다.
    * 새로운 key를 저장했는데 해시충돌이 발생한 경우가 이에 해당한다.
11. 변경 전 value를 저장해둔 oldVal을 반환한다.

### putVal() 메서드의 저장과 수정

**새로운 key와 value를 저장**

* 해시충돌이 발생하지 않는다면 `4`에서 저장
* 해시충돌이 발생하면 `10`에서 저장

**이미 존재하는 key와 value를 수정할 때**

* 해시충돌이 발생하지 않는다면 `8`을 반복하지 않고 `9`에서 value를 수정한 뒤 `11`에서 이전 value를 반환
* 해시충돌이 발생하면 현재 key를 찾을 때까지 `8`을 반복하고 수정, `11`에서 이전 value를 반환