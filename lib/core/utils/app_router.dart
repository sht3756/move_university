import 'package:flutter/material.dart';
import 'package:move_university_project/features/user_details/presentation/user_details_screen.dart';
import 'package:move_university_project/features/user_list/data/models/user_model.dart';
import 'package:move_university_project/features/user_list/presentation/user_list_screen.dart';
import '../constants/app_routes.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.userList:
        return MaterialPageRoute(builder: (_) => const UserListScreen());

      case AppRoutes.userDetails:
        final user = settings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (_) => UserDetailsScreen(user: user),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('잘못된 경로입니다.')),
          ),
        );
    }
  }
}