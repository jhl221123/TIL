# REST API

**인터넷 상의 시스템 간 상호 운용성을 제공하는 방법 중 하나**

* 인터넷 상의 시스템이란 **client to client**, **client to server**, **server to server**를 말한다.
* 시스템 각각이 독립적으로 진화할 수 있도록 해준다.

## REST API의 조건

조건 1~3은 HTTP만 사용해도 자연스레 지킬 수 있다.

1. Client-Server: client와 server는 독립적으로 수행되어야 한다.
2. Stateless: 요청에는 필요한 모든 정보가 포함되어야 한다.
3. Cache: 응답에 캐시 가능성 여부를 명시해야 한다.
4. Uniform Interface: REST API를 구분 짓는 핵심 조건

## Uniform Interface

**리소스 접근 방식을 통일하고 링크를 통해 상태를 전이하는 아키텍쳐**

### Uniform Interface의 4가지 제약 조건

1. Resource-Based: URI는 자원을 기반으로 설계한다.
2. Manipluation Of Resources Through Representations: 리소스 조작은 HTTP 메서드를 활용한다.
3. Self-Descriptive Message: api 스스로가 자신의 정보를 가지고 있어야 한다.
4. Hypermedia As The Engine of Application State: 애플리케이션의 상태는 링크 기반으로 공유된다.

#### 1. Resource-Based, 2. Manipluation Of Resources Through Representations

**▶▶ URI로 지정한 리소스를 Http Method를 통해서 표현하고 구분한다!**

#### 3. Self-Descriptive Message, 4. Hypermedia As The Engine of Application State

**▶▶ api는 자신의 정보와 전이 가능한 상태에 대한 정보를 Hypermedia(링크)의 형태로 포함해야 한다.**

# Hateoas(Hypermedia As The Engine of Application State)

**Hypermedia로 애플리케이션 상태를 전이**

## 상태전이

**api 사용 후, 다음 수행될 수 있는 api를 통해 행동하도록 하는 것**

예를 들어 게시글 조회 api를 사용했을때, 다음 행동으로 아래와 같은 것들이 있다.

* 다음 게시물 조회
* 게시물 좋아요 클릭
* 댓글 달기

이렇게 추가 접근 가능한 행동을 수행하는 것을 상태 전이라고 하며, 해당 정보를 응답에 포함하는 방식을 HATEOAS라 한다.

## 상태전이를 위한 Hypermedia

요청에 대한 응답 데이터 뿐만 아니라, 수행 가능한 api 문서도 Hypermedia(링크) 형태로 전달한다.

```json
{
  "data": {
    "id": 1000,
    "name": "게시글 1",
    "content": "HAL JSON을 이용한 예시 JSON",
    "self": "http://localhost:8080/api/article/1000", // 현재 api 주소
    "profile": "http://localhost:8080/docs#query-article", // 해당 api의 문서
    "next": "http://localhost:8080/api/article/1001", // 다음 게시글 조회
    "comment": "http://localhost:8080/api/article/comment", // 댓글 달기
    "save": "http://localhost:8080/api/favorite/article/1000", // 게시글 좋아요
  },
}
```
#### 장점

* API 버전을 명세하지 않아도 된다.
* 클라이언트는 해당 링크를 참조하는 방식으로, API 그래프 탐색이 가능해진다.
* 응답 데이터 또는 링크가 변경되어도 클라이언트가 일일이 대응하지 않아도 된다.
  * Client 사이드는 "next", "comment"로 링크를 사용하기 때문

## HAL(Hypertext Application Language)

**JSON, XMl 내부에 외부 리소스에 대한 링크를 추가하기 위한 특별한 데이터 타입**

### 리소스와 링크


* 리소스 : 일반적인 data 필드에 해당한다.
* 링크 : 하이퍼미디어로 보통 _self 필드가 링크 필드가 된다.

```json
{
  "data": { // HAL JSON의 리소스 필드
    "id": 1000,
    "name": "게시글 1",
    "content": "HAL JSON을 이용한 예시 JSON"
  },
  "_links": { // HAL JSON의 링크 필드
    "self": {
      "href": "http://localhost:8080/api/article/1000"
    },
    "profile": {
      "href": "http://localhost:8080/docs#query-article"
    },
    "next": {
      "href": "http://localhost:8080/api/article/1001"
    },
    "prev": {
      "href": "http://localhost:8080/api/article/999"
    }
  }
}
```