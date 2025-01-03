# ARP(Address Resolution Protocol)

TCP/IP는 IP 주소를 지정해서 데이터를 전송하고, IP 패킷은 PC나 서버 등의 인터페이스(MAC 주소)까지 전송된다. 이때, IP 주소와 물리적인 네트워크 주소(MAC 주소)를 대응시키는 것이 ARP의 역할이며, 주로 이더넷과 같은 로컬 네트워크에서 사용된다.

이더넷 인터페이스에서 IP 패킷을 내보낼 때는 이더넷 헤더를 덧붙이는데, 여기에 목적지 MAC 주소를 지정해야만 한다. 목적지 IP 주소에 대응하는 MAC 주소는 ARP Table에서 구할 수 있으며, IP 주소와 MAC 주소를 대응시키는 것을 주소 해석이라고 한다.

### LAN과 MAC주소

같은 IP 대역을 공유하는 LAN에서 단말간 통신을 하기 위해 사용자는 IP 주소를 목적지로 지정하지만 실제로는 MAC 주소를 이용해서 목적지를 찾는다.

#### MAC과 IP를 분리해서 사용하는 이유

IP 주소는 논리적인 주소이기 때문에 대상을 정확하게 식별하기 어려울 수 있다. 따라서 웬만해서는 변하지 않는 MAC 주소를 실제 주소로 사용해서 정확하게 식별하도록 한다. 

반대로 MAC 주소만 사용할 경우 라우팅 테이블에서 모든 MAC 주소를 일일히 관리해야 하는데 현실적으로 불가능하다. 때문에 MAC 주소는 로컬 네트워크 내에서만 사용하고, 인터넷과 같은 글로벌 네트워크에서는 IP를 사용한다.

## ARP 동작의 흐름

ARP의 주소 해석 범위는 로컬 네트워크 내의 IP 주소다. 이더넷 인터페이스로 접속된 PC 등의 기기가 IP 패킷을 송신하고자 목적지 IP 주소를 지정할 때, 자동으로 ARP가 수행된다.

![Alt text](<이미지/ARP 동작방식.png>)

1. 먼저 Routing Table을 보고 같은 LAN에 속하는 것을 확인한다.

2. ARP 요청(브로드캐스트)으로 IP 주소에 대응하는 MAC 주소를 질의한다. 요청 패킷에는 송신자의 IP 주소와 MAC 주소, 그리고 목표로 하는 IP 주소가 포함된다.

3. 목적지 IP 주소에 해당하는 장비가 ARP 응답 패킷으로 MAC 주소를 알려준다.

4. 주소 해석한 IP 주소와 MAC 주소의 대응을 ARP 캐시(ARP Table)에 보존한다. 이후 ARP 요청을 다시 보내지 않아도 된다.

> **브로드캐스트**<br>
로컬 네트워크에 속한 모든 장비들에게 보내는 통신