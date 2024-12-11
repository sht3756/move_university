import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_university_project/features/user_details/data/models/user_details_model.dart';
import 'package:move_university_project/features/user_insert/cubit/user_insert_cubit.dart';
import 'package:move_university_project/features/user_insert/cubit/user_insert_state.dart';
import 'package:move_university_project/features/user_insert/presentation/user_insert_screen.dart';
import 'package:move_university_project/features/user_list/cubit/user_list_cubit.dart';
import 'package:move_university_project/features/user_list/data/models/user_model.dart';
import 'package:move_university_project/shared/widgets/empty_widget.dart';
import '../cubit/user_list_state.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원 리스트'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet<void>(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return const UserInsertScreen();
                },
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<UserInsertCubit, UserInsertState>(
              listener: (BuildContext context, state) {
            state.whenOrNull(success: (UserDetailsModel details) {
              context.read<UserListCubit>().fetchUsers();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('등록 성공하였습니다.')),
              );
            });
          }),
        ],
        child: BlocConsumer<UserListCubit, UserListState>(
          listener: (context, state) {
            state.whenOrNull(error: (e, s) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            });
          },
          builder: (context, state) {
            return state.when(
                initial: () => const Center(child: Text('init')),
                loading: () => const Center(child: CircularProgressIndicator()),
                success: (
                  List<UserModel> users,
                  DocumentSnapshot? lastDocument,
                ) =>
                    users.isEmpty
                        ? emptyWidget()
                        : userListFragment(users, lastDocument),
                error: (e, s) => Center(child: Text('Error: $e')));
          },
        ),
      ),
    );
  }

  Widget userListFragment(
      List<UserModel> users, DocumentSnapshot? lastDocumentId) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.pixels ==
                notification.metrics.maxScrollExtent) {
          context.read<UserListCubit>().fetchUsersMore();
          return true;
        }
        return false;
      },
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(user.name),
            subtitle: Text(user.phone),
            onTap: () async {
              final result = await Navigator.pushNamed(context, '/userDetails',
                  arguments: user);
              if (result == true) {
                context.read<UserListCubit>().fetchUsers();
              }
            },
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12),
          );
        },
      ),
    );
  }
}
