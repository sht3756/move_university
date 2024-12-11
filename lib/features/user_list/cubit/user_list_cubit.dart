import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_university_project/features/user_list/data/models/user_model.dart';
import 'package:move_university_project/features/user_list/data/repositories/user_repository.dart';

import 'user_list_state.dart';

class UserListCubit extends Cubit<UserListState> {
  final UserRepository _repository;
  DocumentSnapshot? _lastDocument;

  UserListCubit(this._repository) : super(const UserListState.initial());

  Future<void> fetchUsers({int limit = 10}) async {
    emit(const UserListState.loading());

    try {
      final result = await _repository.fetchUsers(limit: limit);
      _lastDocument = result['lastDocument'];

      emit(UserListState.success(
        users: result['users'],
        lastDocument: _lastDocument,
      ));
    } catch (e, s) {
      emit(UserListState.error(e: e, s: s));
    }
  }

  Future<void> fetchUsersMore(
      {int limit = 10}) async {
    if (_lastDocument == null) return;

    try {
      final result = await _repository.fetchUsers(
        limit: limit,
        lastDocumentId: _lastDocument,
      );

      _lastDocument = result['lastDocument'];

      state.whenOrNull(success: (List<UserModel> users,DocumentSnapshot? documentSnapshot) {
        final updatedUsers = List<UserModel>.from(users)..addAll(result['users']);
        emit(UserListState.success(
          users: updatedUsers,
          lastDocument: _lastDocument,
        ));
      });
    } catch (e, s) {
      emit(UserListState.error(e: e, s: s));
    }
  }
}
