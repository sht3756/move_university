import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_university_project/features/user_details/cubit/user_details_cubit.dart';
import 'package:move_university_project/features/user_details/cubit/user_details_state.dart';
import 'package:move_university_project/features/user_details/data/repositories/user_details_repository.dart';
import 'package:move_university_project/features/user_list/data/models/user_model.dart';

import '../data/models/user_details_model.dart';

class UserDetailsScreen extends StatefulWidget {
  final UserModel user;

  const UserDetailsScreen({super.key, required this.user});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final userData = widget.user;

    return Scaffold(
        appBar: AppBar(
          title: Text('${userData.name}의 상세'),
        ),
        body: BlocProvider(
          create: (BuildContext context) => UserDetailsCubit(UserDetailsRepository(FirebaseFirestore.instance))..fetchUserDetails(userName: userData.email),
          child: BlocConsumer<UserDetailsCubit, UserDetailsState>(
            listener: (context, state) {
              state.whenOrNull(
                error: (e, s) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                }
              );
            },
            builder: (context, state) {
              return state.when(
                initial: () => const Center(child: Text('init'),),
                loading: () => const Center(child: CircularProgressIndicator(),),
                success: (UserDetailsModel data) => userDetailsFragment(data),
                error: (e, s) => Center(child: Text('Error : $e'),),
              );
            },
          ),
        ));
  }

  Widget userDetailsFragment(UserDetailsModel data) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Center(child: Text(data.name)),
        Center(child: Text(data.email)),
        Text(data.registerDate.toString()),
        Text(data.modifiedDate.toString()),
      ],
    );
  }
}
