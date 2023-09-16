# BCrypt

**Blowfish 기반으로 설계된 가장 강력한 해시 메커니즘 중 하나**

* digest의 길이는 60으로 고정
* digest 내부에 Salt를 포함하기 때문에 레인보우 테이블 공격에 대비할 수 있다.
* 반복횟수를 늘리고, 그에 따라 연산속도를 늦출 수 있다. 이를 통해 연산 능력이 증가하더라도 브루트 포스 공격에 대비할 수 있다.

### 레인보우 테이블

**해시 함수로 변환 가능한 모든 해시 값을 저장해둔 표**

* 해시 함수로 저장된 비밀번호를 원래의 비밀번호를 추출하기 위해 사용
* 조합 가능한 모든 문자열을 하나씩 대입하는 브루트 포스 공격에 사용

## Salt

**같은 문자열을 다른 digest로 생성하기 위해 사용**

```java
salt = $2a$10$EXRW6iwQBTB3u6xChZqXIu //29
digest = $2a$10$EXRW6iwQBTB3u6xChZqXIuaMEQbfSR9T0PLDbXwPwSmS5t9jttdKW //60
```

* 60자의 digest 중 29자를 차지
* digest가 Salt를 포함하기 때문에 간편하게 평문과 비교할 수 있다.

# 스프링이 제공하는 BCryptPasswordEncoder

## 비밀번호 암호화 과정

1. BCryptPasswordEncoder.encode() 메서드로 암호화
2. BCrypt.gensalt() 메서드로 Salt 생성
3. BCrypt.hashpw('비밀번호', '생성된 Salt') 메서드로 digest 생성

## 비밀번호 확인 과정

**기존 digest에서 Salt를 추출하고, 해당 Salt를 사용해서 입력된 비밀번호를 암호화한 후 비교**

1. BCryptPasswordEncoder.matches('입력된 비밀번호', '기존 digest') 메서드 호출
2. 이때 내부적으로 digest에 포함된 Salt를 추출
```java
//BCrypt.hashpw()
real_salt = salt.substring(off + 3, off + 25);
```
3. 입력된 비밀번호를 추출한 Salt를 사용해 digest 생성
4. 기존의 digest와 새로운 digest를 비교