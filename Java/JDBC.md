# JDBC

**애플리케이션을 데이터베이스와 연결하는 자바 표준 API** 

추상화를 통해 DBMS의 종류에 상관없이, 일관된 방법으로 데이터 접근 코드를 작성할 수 있도록 지원한다.

![Alt text](<이미지/JDBC 프로그래밍 구조.png>)

## JDBC 드라이버

* JDBC API는 JDBC 드라이버를 거쳐 데이터베이스와 통신한다.
* 드라이버는 JDBC API에 맞게 설계된다.

### 드라이버 로딩
```java
Class.forName("Driver class full name");

// 클래스를 로드하면 내부 static 블록을 통해 등록
static {
    try {
        java.sql.DriverManager.registerDriver(new Driver());
    } catch (SQLException E) {
        throw new RuntimeException("Can't register driver!");
    }
}
```

### 커넥션

```java
DriverManager.getConnection(JDBC URL, user, password)
```

* JDBC를 이용해서 데이터베이스를 사용하려면 데이터베이스와 연결된 커넥션이 필요하다.
* DriverManager클래스를 사용해 커넥션 객체를 생성한다.

### Statement

* 커넥션 객체를 통해 생성한다.
* 실행하려는 쿼리는 문자열로 생성한다.

```java
stmt = conn.createStatement();
stmt.executeQuery("insert into USER (USERID, NAME, EMAIL) values ('foo', 'bar', 'foo@bar')");
```

### PreparedStatement

* Statement와 동일한 기능을 제공하지만 쿼리의 틀을 미리 생성해 두고 값을 나중에 지정할 수 있다.

```java
conn.prepareStatement("insert into USER (USERID, NAME, EMAIL) values (?, ?, ?)");
```

### Statement vs PreparedStatement

#### SQL Injection

* Statement는 전달된 변수가 SQL 형식일 경우, SQL 구문으로 인식해 보안 문제가 발생할 수 있다.
* PreparedStatement는 SQL 형식으로 입력해도 내부적으로 일반 문자열로 변환하기 때문에 안전하다.

#### 캐시

* Statement는 SQL을 호출할 때마다 매번 컴파일 과정을 거친다.
* PreparedStatement는 SQL을 JDBC 드라이버 내부 캐시에 저장하기 때문에 최초 한 번만 컴파일한다.

### ResultSet

* 조회 결과를 반환할 때 사용한다.
* 최초에 커서는 1행 이전에 존재하기 때문에 next() 메소드로 데이터 존재 여부를 확인해야한다.