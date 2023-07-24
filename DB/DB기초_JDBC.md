# 데이터베이스
데이터를 지속적으로 관리하고 보호하는 것이 주목적이며, DBMS를 통해 관리한다.

## 테이블

데이터를 저장하는 곳으로 Column과 Record로 구성된다.

![Alt text](<이미지/테이블 이미지.png>)

### 주요키와 인덱스

주요키는 특정 Record를 좀 더 빠르게 찾기위해 사용하며, 주요키 Column의 모든 Record는 서로 다른 값을 가져야한다. 반면 인덱스는 중복된 값에 대한 정렬이 가능하다.

## SQL

데이터베이스로부터 데이터를 조회하고 삭제하는 등의 작업을 수행할 때 사용하는 언어다.

### 데이터 삽입 쿼리

테이블에 데이터를 추가할 때는 insert 쿼리를 사용한다.

```sql
insert into [테이블이름] ([Column1], [Column2]) values ([value1], [value1])
```

* 값을 지정하지 않으면 null이 들어간다.

* 문자열은 작은따옴표를 사용해서 표현한다.

### 데이터 조회 쿼리

테이블에 저장된 데이터를 조회할 때에는 select 쿼리를 사용한다.

```sql
select [Column1], [Column2] from [테이블이름]
```

* Column 전체를 조회하려면 '*'를 사용하면 된다.

* where, order by절을 이용해서 추가적인 처리를 할 수 있다.

### 데이터 수정 쿼리

데이터를 수정할 때에는 update 쿼리를 사용한다.

```sql
update [테이블이름] set [Column1]=[value1], [Column2]=[value2] where [조건]
```

* where 절을 사용해서 조건을 명시하지 않으면 모든 레코드의 값을 변경한다.

### 데이터 삭제 쿼리

delete 쿼리를 사용해서 레코드 단위로 데이터를 삭제할 수 있다.

```sql
delete from [테이블이름] where [조건]
```

* where 절을 사용해서 조건을 명시하지 않으면 모든 레코드를 삭제한다.

### 조인

두 개 이상의 테이블에서 관련 있는 데이터를 함께 조회할 때 사용한다.

```sql
select * from <테이블1> join <테이블2> on <조인 조건> where [검색 조건]
```

#### 조인 종류

조인은 다음 네 가지 종류가 있다.

|조인|설명|
|---|---|
|INNER JOIN|두 테이블을 조인할 때, 두 테이블에 모두 지정한 열의 데이터가 있어야 한다.|
|OUTER JOIN|두 테이블을 조인할 때, 1개의 테이블에만 데이터가 있어도 결과가 나온다.|
|CROSS JOIN|한쪽 테이블의 모든 행과 다른 쪽 테이블의 모든 행을 조인하는 기능이다.|
|SELF JOIN|자신이 자신과 조인한다는 의미로, 1개의 테이블을 사용한다.|

OUTER JOIN에는 다음 세 가지 종류가 있다.

|조인|설명|
|---|---|
|LEFT OUTER JOIN|왼쪽 테이블의 모든 값이 출력되는 조인|
|RIGHT OUTER JOIN|오른쪽 테이블의 모든 값이 출력되는 조인|
|FULL OUTER JOIN|왼쪽, 오른쪽 테이블의 모든 값이 출력되는 조인|

# JDBC

자바에서 데이터베이스와 관련된 작업을 처리할 떄 사용하는 API로, DBMS의 종류에 상관없이 하나의 JDBC API를 사용해서 처리할 수 있다.

![Alt text](<이미지/JDBC 프로그래밍 구조.png>)

## JDBC 드라이버

DBMS와 통신을 담당하는 자바 클래스로 다음과 같이 로딩한 후 작업을 수행한다.

```java
try{
    Class.forName("JDBC 드라이버 클래스의 완전한 이름");
} catch(ClassNotFoundException ex) {
    // 지정한 클래스가 존재하지 않는 경우 에러 발생
}
```

드라이버는 클래스 로드에 의해 로드된 후 초기화 과정에서 내부 static 블록을 통해 등록된다.

아래는 MySQL 드라이버의 일부분이다.

```java
public class Driver extends NonRegisteringDriver implements java.sql.Driver {
    
    static {
        try {
            java.sql.DriverManager.registerDriver(new Driver());
        } catch (SQLException E) {
            throw new RuntimeException("Can't register driver!");
        }
    }
}
```

## 커넥션

* JDBC를 이용해서 데이터베이스를 사용하려면 데이터베이스와 연결된 커넥션이 필요하다.

* DriverManager클래스를 사용해 커넥션 객체를 생성할 수 있다.

## PreparedStatement

* Statement와 동일한 기능을 제공하지만 쿼리의 틀을 미리 생성해 두고 값을 나중에 지정할 수 있다.

```java
PreparedStatement pstmt = null;

pstmt = conn.prepareStatement(
    "insert into USER (USERID, NAME, EMAIL) values (?, ?, ?)"
    );

pstmt.setString(1, "userA");
pstmt.setString(2, "momo");
pstmt.setString(3, "momo@a.com");
```

## ResultSet

* 데이터 조회 시 해당 타입으로 결과를 반환하며, next() 메소드를 사용해 결과가 존재하는지 알 수 있다.

* 커서를 통해서 각 행의 데이터에 접근하는데, 처음엔 커서가 1행 이전에 존재하기 때문에 next() 메소드를 사용해 커서를 다음 행으로 이동시킨 후 결과를 조회할 수 있다.