import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:move_university_project/features/user_details/cubit/user_details_cubit.dart';
import 'package:move_university_project/features/user_details/data/repositories/user_details_repository.dart';
import 'package:move_university_project/features/user_list/cubit/user_list_cubit.dart';
import 'package:move_university_project/features/user_list/data/repositories/user_repository.dart';
import 'package:move_university_project/features/user_list/presentation/user_list_screen.dart';

import 'core/utils/app_router.dart';
import 'firebase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(options: FirebaseConfig.options);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserListCubit(
            UserRepository(FirebaseFirestore.instance),
          )..fetchUsers(),
          child: const UserListScreen(),
        ),
        BlocProvider(
          create: (_) => UserDetailsCubit(
            UserDetailsRepository(FirebaseFirestore.instance),
          ),
          child: const UserListScreen(),
        ),
      ],
      child: const MaterialApp(
        title: '관리자 앱',
        initialRoute: '/',
        onGenerateRoute: AppRouter.generateRoute, // 동적 라우팅 사용
      ),
    );
  }
}
