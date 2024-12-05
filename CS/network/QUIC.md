# QUIC(Quick UDP Internet Connections)

**HTTP에 적합한 UDP 기반의 프로토콜**

사용자에게 더 빠르게 정보를 전달하기 위해 Google에서 개발을 시작

### 전송 속도 향상

* UDP 기반의 통신으로 handshake 과정 자체가 없으며, 전송 왕복 시간(RTT, Round-Trip Time)이 0~1이다.
* "Connection ID"로 생성된 초기화 키와 함께 데이터를 바로 전송한다.
* "Connection ID"로 클라이언트를 식별하기 때문에 도중에 IP 주소가 변경되어도 동일한 연결을 유지할 수 있다.

### 보안성 향상

* TLS 1.3을 사용
* 필요에 따라 Source Address Token을 발급하고, IP 변조 및 재생공격에 대한 검증을 수행

### 멀티플렉싱(multiplexing)

* 하나의 커넥션 안에서 여러 스트림을 통해 동시에 데이터를 전송
* HTTP/2에서도 제공하는 기능이지만 조금 더 향상된 기능을 제공
* 유실된 패킷이 속한 스트림만 Block, 다른 스트림은 별도의 Block 없이 지속적으로 처리 할 수 있도록 설계

### 향상된 오류정정

* 전방 오류정정 FEC(Forward Error Correction) 방식을 이용
* 패킷이 전송 중 변조나 훼손이 발생했을 경우, 정정비트를 통해 훼손된 비트를 복구하도록 설계