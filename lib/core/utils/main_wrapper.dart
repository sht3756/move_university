import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_university_project/features/user_details/cubit/user_details_cubit.dart';
import 'package:move_university_project/features/user_details/data/repositories/user_details_repository.dart';
import 'package:move_university_project/features/user_insert/cubit/user_insert_cubit.dart';
import 'package:move_university_project/features/user_insert/data/repositories/user_insert_repository.dart';
import 'package:move_university_project/features/user_list/cubit/user_list_cubit.dart';
import 'package:move_university_project/features/user_list/data/repositories/user_repository.dart';

class MainWrapper extends StatelessWidget {
  final Widget child;

  const MainWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserListCubit(
            UserRepository(FirebaseFirestore.instance),
          )..fetchUsers(),
        ),
        BlocProvider(
          create: (_) => UserInsertCubit(
            UserInsertRepository(FirebaseFirestore.instance),
          ),
        ),
        BlocProvider(
          create: (_) => UserDetailsCubit(
            UserDetailsRepository(FirebaseFirestore.instance),
          ),
        ),
      ],
      child: child,
    );
  }
}
