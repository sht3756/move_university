# move_university_project

lib/
├── core/ : 핵심 유틸과 설정 파일
│   ├── firebase_config.dart : Firebase 초기화 및 설정
│   ├── constants/ 
│   │   └── enum/ 
│   │       └── user_role_enum.dart : 작성 모드 enum
│   └── utils/ : 유틸 
│       └── stack_trace_converter.dart : Error, StackTrace 변환 
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
│   │   ├── cubit/
│   │   │   ├── user_insert_cubit.dart
│   │   │   └── user_insert_state.dart
│   │   ├── data/
│   │   │   └── models/
│   │   │       └── user_insert_model.dart
│   │   └── presentation/
│   │       └── user_insert_screen.dart
│   └── user_list/ : 사용자 리스트 페이지 관련 로직 및 UI
│       ├── cubit/
│       │   ├── user_list_cubit.dart
│       │   └── user_list_state.dart
│       ├── data/
│       │   ├── models/
│       │   │   └── user_model.dart
│       │   └── repositories/
│       │       └── user_repository.dart
│       └── presentation/
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