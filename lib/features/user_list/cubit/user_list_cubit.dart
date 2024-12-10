import 'package:bloc/bloc.dart';
import 'package:move_university_project/features/user_list/data/repositories/user_repository.dart';

import 'user_list_state.dart';

class UserListCubit extends Cubit<UserListState> {
  final UserRepository _repository;

  UserListCubit(this._repository) : super(const UserListState.initial());

  Future<void> fetchUsers({int limit = 10}) async {
    emit(const UserListState.loading());

    try {
      final users = await _repository.fetchUsers(limit: limit);
      emit(UserListState.success(users: users, hasMore: false));
    } catch (e, s) {
      emit(UserListState.error(e: e, s: s));
    }
  }

  Future<void> fetchUsersMore(
      {int limit = 10, required String lastDocumentId}) async {
    try {

    } catch (e, s) {
      emit(UserListState.error(e: e, s: s));
    }
  }
}
