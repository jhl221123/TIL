# putVal()

```java
final V putVal(K key, V value, boolean onlyIfAbsent) {
        if (key == null || value == null) throw new NullPointerException(); // 1
        int hash = spread(key.hashCode());
        int binCount = 0;
```
1. ConcurrentHashMap은 null을 허용하지 않기 때문에 key 또는 value가 null일 경우 NullPointerException이 발생한다.

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

3. table은 버킷 배열로 버킷에 처음 저장될 때 초기화한다.

4. 현재 해시값에 해당하는 노드가 존재하지 않는다면(버킷이 비어있다면) casTabAt() 메서드를 호출, 내부적으로 Unsafe 클래스의 인스턴스로 compareAndSetObject() 메서드를 호출하고 하드웨어 수준에서 원자적 연산이 수행된다.

5. 버킷을 리사이징 해야할 경우, 정적 내부 클래스인 ForwardingNode를 사용해서 helpTransfer() 메서드를 호출한다.

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

9. 버킷에 존재하는 노드 중, 현재 key와 일치하는 것을 찾으면 이전 value를 oldVal에 저장하고, onlyIfAbsent에 따라 value를 수정한다.

10. 버킷에 현재 key와 일차히는 노드가 없다면, 새로운 노드를 생성하고 저장한다. 새로운 key를 저장했는데 해시충돌이 발생한 경우가 이에 해당한다.

11. 변경 전 value를 저장해둔 oldVal을 반환한다.

## put() 메서드로 예를 들어보자.

#### 새로운 key와 value를 저장할 때

해시충돌이 발생하지 않는다면 `4`에서 저장되고, 해시충돌이 발생하면 `10`에서 저장된다.

#### 이미 존재하는 key와 value를 수정할 때

해시충돌이 발생하지 않는다면 `8`을 반복하지 않고 `9`에서 value를 수정한 뒤 `11`에서 이전 value를 반환한다. 해시충돌이 발생하면 현재 key를 찾을 때까지 `8`을 반복하고 수정, 반환한다.