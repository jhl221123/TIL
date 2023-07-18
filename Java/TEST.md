# 슬랙 자동 알림 테스트

# paths: - 'Java/**' 지정
* 해당 파일은 대상에 포함되어야 한다.

# paths: - 'Java/**' 제거
* 하나의 이벤트에 paths, paths-ignore를 동시에 사용할 수 없다.

# 쉘 스크립트 실행 테스트
- 실행 경로 변경
- 실행 권한 설정
- bash 추가
- 스크립트 위치 변경
- commit id 출력 테스트
- 이벤트, 액션 경로 확인 테스트
- github.event 제거
- post-message.sh 경로 변경
- 실행 경로 변경
- github.action_path 제거
- workflows 경로 확인
- checkout action에서 경로 확인
- 스크립트 위치 변경
- bash 추가
- ./ -> /
- 스크립트 위치 변경..
- 부분 체크아웃 설정 제거
- 스크립트 폴더 생성 후 post-message.sh 이동

# 쉘 스크립트 작성
- Java 폴더로 경로 이동 테스트
- 경로 수정
- github.event.commits 출력 테스트
- 출력 수정
- 슬랙 전송 테스트
- 슬랙 전송 테스트
- 커밋 메시지로 전송 테스트
- 경로 변경하고 테스트
- tr사용으로 공백 치환 테스트
- { ;} 사용후 테스트
- 변수 할당 후 테스트
- tr 결과 확인