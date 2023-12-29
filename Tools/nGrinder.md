# nGrinder

**부하 테스트를 간편하게 할 수 있는 플랫폼**

* 스크립트(groovy, jython) 작성을 통해 테스트 수행
* 테스트, 모니터링, 결과 도출을 동시에 수행

## 구성 요소

### 컨트롤러
* 성능 테스트를 위한 웹 인터페이스를 제공한다.
* 테스트 프로세스를 조정한다.
* 테스트 통계를 수집하고 표시한다.
* 사용자가 스크립트를 생성하고 수정할 수 있다.

### 에이전트
* 에이전트 모드에서 실행할 때, 대상 시스템에 부하를 주는 프로세스 및 스레드를 실행한다.
* 모니터 모드에서 실행할 때, 대상 시스템 성능(CPU, 메모리 등)을 모니터링한다.

## 동작 과정

* 에이전트 실행
  * 컨트롤러와 연결
  * `AgentControllerServer`와 연결: `AgentControllerServer`는 에이전트 풀을 관리
* 사용자가 성능 테스트를 시작
  * `ConsoleManager`로 부터 새로운 `SingleConsole`을 생성
  * 필요한 수의 에이전트가 `AgentControllerServer`로 부터 `SingleConsole`로 전달
* `SingleConsole`은 테스트 스크립트와 테스트 자원을 전달 받은 에이전트들에게 할당하고 테스트 흐름을 제어
  * 테스트 완료 후, 에이전트와 싱글 콘솔은 각각 `AgentControllerServer`와 `ConsoleManager`로 반환