# 이사대학 [신희태] 과제

## 설치 및 실행 방법
- 프로젝트 클론
```bash
git clone https://github.com/sht3756/move_university.git
```
- .env파일에 API 중요 문서 복사후 붙여넣기

- debug mode 실행
```bash
flutter pub get
flutter pub run build_runner build
flutter run 

```

- release mode 실행
```bash
flutter pub get
flutter pub run build_runner build
flutter run --release
```

## 주요 기능 설명 
- 사용자 목록 조회 : NotificationListener 를 통해 무한 스크롤 기능 연동
- 사용자 상세보기, 수정 및 삭제 : 작성 모드를 통해 수정 모드 및 삭제 기능 연동
- 사용자 추가 : 바텀 모달 시트를 통해 사용자 추가 기능 연동 
- 무한 스크롤 : ScrollNotification을 통한 스크롤 감지 및 무한 스크롤 기능 연동
- FireStore 연동 및 데이터 관리 : Cloud FireStore 및 데이터 관리 연동

## 기술
- Flutter(And, IOS), Bloc(상태관리), Cloud FireStore(서비리스)  

## 패키지
```bash
  firebase_core: ^3.8.1
  cloud_firestore: ^5.5.1
  bloc: ^8.1.4
  flutter_dotenv: ^5.2.1
  freezed_annotation: ^2.4.4
  flutter_bloc: ^8.1.6
  intl: ^0.20.1
```

## 폴더구조 및 설명

``` bash
lib/
├── core/ : 핵심 유틸과 설정 파일
│   ├── firebase_config.dart : Firebase 초기화 및 설정
│   ├── constants/ 변하지 않는 상수 
│   │   ├── enum/ 
│   │   │   └── user_role_enum.dart : 작성 모드 enum
│   │   └── app_routes.dart : 앱 라우트 
│   └── utils/ : 유틸 
│       ├── app_router.dart : 앱 라우터 정리 
│       ├── document_snapshot_converter.dart : 파이어베이스 DocumentSnpahsot 타입 변환
│       ├── format_phone_number.dart : 핸드폰 - 포멧
│       ├── format_time.dart : 시간 - 포멧 
│       ├── main_wrapper.dart : 메인 의존성 파일 분리
│       ├── stack_trace_converter.dart : Error, StackTrace 변환
│       ├── time_stamp_converter.dart : 파이어베이스 Timestamp 타입 변환
│       └── valid_utils.dart : 정규식 유틸 분리
├── features/ : 기능 위주의 디렉토리 
│   ├── user_details/ : 사용자 상세 페이지 관련 로직 및 UI
│   │   ├── cubit/ : 상태 관리 및 비즈니스 로직
│   │   │   ├── user_details_cubit.dart 
│   │   │   └── user_details_state.dart
│   │   ├── data/ : 데이터 모델 및 레포지토리 정의
│   │   │   ├── models/
│   │   │   │   └── user_details_model.dart : 유저 상세페이지 모델 정의
│   │   │   └── repositories/ : Firebase 데이터 통신에 필요한 비즈니스 로직
│   │   │       └── user_details_repository.dart
│   │   └── presentation/ : 화면 
│   │       └── user_details_screen.dart
│   ├── user_insert/ : 사용자 등록 페이지 관련 로직 및 UI
│   │   ├── cubit/ : 상태 관리 및 비즈니스 로직
│   │   │   ├── user_insert_cubit.dart
│   │   │   └── user_insert_state.dart
│   │   ├── data/ : 데이터 모델 및 레포지토리 정의
│   │   │   └── repositories/ : Firebase 데이터 통신에 필요한 비즈니스 로직
│   │   │       └── user_insert_repository.dart 
│   │   └── presentation/ : 화면
│   │       └── user_insert_screen.dart
│   └── user_list/ : 사용자 리스트 페이지 관련 로직 및 UI
│       ├── cubit/ : 상태 관리 및 비즈니스 로직
│       │   ├── user_list_cubit.dart
│       │   └── user_list_state.dart
│       ├── data/ : 데이터 모델 및 레포지토리 정의
│       │   ├── models/
│       │   │   └── user_model.dart : 유저 모델 정의
│       │   └── repositories/ : Firebase 데이터 통신에 필요한 비즈니스 로직
│       │       └── user_repository.dart
│       └── presentation/ : 화면
│           └── user_list_screen.dart
├── shared/ : 재사용 가능한 컴포넌트 및 스타일 
│   ├── widgets/ 
│   │   ├── empty_widget.dart : 빈 리스트
│   │   ├── build_text_field.dart : 입력 필드
│   │   ├── cupertino_alert_dialog.dart : Alert 다이얼로그 
│   │   ├── cupertino_confirm_dialog.dart : Confirm 다이얼로그
│   │   └── user_card.dart : 유저 카드 
│   └── styles/
│       └── app_theme.dart
├── main.dart : 앱 진입점
```
## 스크린샷

### iOS
| 화면 | 이미지 |
|------|--------|
| 리스트 | <img src="https://github.com/user-attachments/assets/f12354d2-7eb4-40ed-acf3-6b37ff8f8de0" width="300" /> |
| 리스트 - 삭제 | <img src="https://github.com/user-attachments/assets/f8bf59d6-2a1f-4320-bfc9-9c6b16f542d2" width="300" /> |
| 상세 | <img src="https://github.com/user-attachments/assets/eeb52c41-e12c-4b1c-bff8-151922e5bbe9" width="300" /> |
| 상세 - 수정 | <img src="https://github.com/user-attachments/assets/9e983120-d85b-492a-a20f-4b83129e21d0" width="300" /> |
| 상세 - 삭제 | <img src="https://github.com/user-attachments/assets/be0edc20-ba87-488f-9c33-0a2d064a125b" width="300" /> |
| 추가 | <img src="https://github.com/user-attachments/assets/2b98033c-eb35-45a8-a601-f798ba872670" width="300" /> |

---

### Android
| 화면 | 이미지 |
|------|--------|
| 리스트 | <img src="https://github.com/user-attachments/assets/a3506614-4462-4983-be0b-1aa38233c232" width="300" /> |
| 리스트 - 삭제 | <img src="https://github.com/user-attachments/assets/ef77894a-e35d-41d6-8e60-68d6651009da" width="300" /> |
| 상세 | <img src="https://github.com/user-attachments/assets/496505e1-3341-49a8-95c0-515b85665d45" width="300" /> |
| 상세 - 수정 | <img src="https://github.com/user-attachments/assets/2b724a79-9ec6-4cf6-ac76-43934c4bcbba" width="300" /> |
| 상세 - 삭제 | <img src="https://github.com/user-attachments/assets/f1b50dd8-6add-455a-b074-77beb655075e" width="300" /> |
| 추가 | <img src="https://github.com/user-attachments/assets/1f2bf86b-c0da-4bfe-9732-d6b254394b0b" width="300" /> |

