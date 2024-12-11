import 'package:bloc/bloc.dart';
import 'package:move_university_project/features/user_details/data/models/user_details_model.dart';
import 'package:move_university_project/features/user_insert/data/repositories/user_insert_repository.dart';

import 'user_insert_state.dart';

class UserInsertCubit extends Cubit<UserInsertState> {
  final UserInsertRepository _repository;

  UserInsertCubit(this._repository) : super(const UserInsertState.initial());

  // 등록하기
  Future<void> insertUserDetails(UserDetailsModel userDetail) async {
    emit(const UserInsertState.loading());

    try {
      await _repository.insertUserDetails(userDetail);
      emit(UserInsertState.success(userDetail: userDetail));
    } catch(e, s) {
      emit(UserInsertState.error(e: e, s: s));
    }
  }
}