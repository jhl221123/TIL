# TCP

**신뢰성이 있는 애플리케이션 간의 데이터 전송을 하기 위한 프로토콜**

TCP/IP 통신은 실제 요청을 전송하기 전에 3-way handshake를 통해 서버와 커넥션을 생성하고 4-way handshake로 커넥션을 종료한다.

![Alt text](<이미지/3-way handshake.png>)

1. 클라이언트는 서버에 접속을 요청하는 SYN 패킷을 보낸다.

2. 서버는 SYN요청을 받고 클라이언트에게 ACK와 SYN flag가 설정된 패킷을 발송한 후, 클라이언트가 ACK로 응답하기를 기다린다.

3. 클라이언트가 서버에게 ACK를 보내면 연결이 이루어지며, 데이터를 전송할 수 있게 된다.

TCP 커넥션 연결은 DNS를 통해 IP 주소를 조회한 후, 그리고 HTTPS 통신을 위한 SSL(TLS) 커넥션 생성 전에 이루어진다. 커넥션이 생성되었다면 HTTP 메시지에 포트 번호와 부가 정보들이 포함된 TCP헤더를 추가하고 애플리케이션 간 데이터 송수신이 수행된다.

![Alt text](<이미지/TCP 헤더.png>)

TCP는 MSS를 넘는 크기의 데이터는 분할해서 전송하는데, TCP 헤더에 포함된 시퀀스 번호로 데이터가 어떻게 분할되었는지, ACK 번호로 데이터를 바르게 수신했음을 알 수 있다.

> MSS(Maximum Segment Size)<br>
TCP에서 애플리케이션의 데이터를 분할하는 단위로 표준 크기는 1460 바이트이다.

데이터 전송이 끝나면 4-way handshake로 커넥션을 종료한다.

![Alt text](<이미지/4-way handshake.png>)

1. 클라이언트가 연결을 종료하겠다는 FIN 플래그를 전송한다.

2. 서버는 일단 확인메시지를 보내고 자신의 통신이 끝날때까지 기다린다.

3. 서버가 통신이 끝났으면 연결이 종료되었다고 클라이언트에게 FIN 플래그를 전송한다.

4. 클라이언트는 확인했다는 메시지를 보낸다.

Server에서 FIN 플래그를 전송하기 전에 전송한 데이터 패킷이 Routing 지연이나 패킷 유실로 인한 재전송 등으로 인해 FIN 플래그보다 늦게 도착하는 상황이 발생한다면 해당 패킷은 Drop되고 데이터는 유실된다.

이런 문제를 방지하기 위해 클라이언트는 서버로부터 FIN 플래그를 수신하더라도 일정시간 동안 기다리는데 이를 "TIME_WAIT" 라고 한다.