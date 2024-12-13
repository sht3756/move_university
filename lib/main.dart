import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:move_university_project/core/utils/main_wrapper.dart';

import 'core/utils/app_router.dart';
import 'firebase_config.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (FlutterErrorDetails details) {
      log('플러터 내부 에러', error: details.exception, stackTrace: details.stack);
      if (kDebugMode) {
        FlutterError.presentError(details);
      } else {
        log('프로덕션 환경 에러 발생: ${details.exception}');
      }
    };

    await dotenv.load();
    await Firebase.initializeApp(options: FirebaseConfig.options);

    runApp(const MyApp());
  }, (Object error, StackTrace stackTrace) {
    log('플러터 외부 에러', error: error, stackTrace: stackTrace);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainWrapper(
      child: MaterialApp(
        title: '관리자 앱',
        initialRoute: '/',
        onGenerateRoute: AppRouter.generateRoute, // 동적 라우팅 사용
      ),
    );
  }
}
