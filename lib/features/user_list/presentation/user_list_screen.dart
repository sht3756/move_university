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
  double _swipeOffset = 0.0;
  final double _maxSwipeOffset = 30.0;

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
              icon: const Icon(Icons.add))
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
                  String? lastDocumentId,
                  bool hasMore,
                ) =>
                    users.isEmpty
                        ? emptyWidget()
                        : userListFragment(users, lastDocumentId, hasMore),
                error: (e, s) => Center(child: Text('Error: $e')));
          },
        ),
      ),
    );
  }

  Widget userListFragment(
      List<UserModel> users, String? lastDocumentId, bool hasMore) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _swipeOffset = 0.0;
        });
      },
      child: Container(
        color: Colors.grey[300],
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  if (details.delta.dx < 0) {
                    _swipeOffset = (_swipeOffset - details.delta.dx)
                        .clamp(0.0, _maxSwipeOffset);
                  } else if (details.delta.dx > 0) {
                    _swipeOffset = 0.0;
                  }
                });
              },
              onHorizontalDragEnd: (_) {
                if (_swipeOffset < _maxSwipeOffset * 0.5) {
                  setState(() {
                    _swipeOffset = 0.0;
                  });
                }
              },
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: Colors.white,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform:
                        Matrix4.translationValues(-_swipeOffset, 0.0, 0.0),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(user.name),
                      subtitle: Text(user.phone),
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                            context, '/userDetails',
                            arguments: user);
                        if (result == true) {
                          context.read<UserListCubit>().fetchUsers();
                        }
                      },
                      contentPadding: _swipeOffset >= _maxSwipeOffset * 0.5
                          ? const EdgeInsets.only(right: 0)
                          : null,
                      trailing: _swipeOffset >= _maxSwipeOffset * 0.5
                          ? ElevatedButton(
                              onPressed: () async {
                                final confirm =
                                    await showDeleteConfirmationDialog(
                                        context, user.name);
                                if (confirm) {
                                  setState(() {
                                    users.removeAt(index);
                                    _swipeOffset = 0.0;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text(
                                '삭제',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : const Icon(Icons.arrow_forward_ios_rounded,
                              size: 12),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<bool> showDeleteConfirmationDialog(
      BuildContext context, String item) async {
    return await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('삭제 확인'),
              content: Text('$item을(를) 삭제하시겠습니까?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text('삭제'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
