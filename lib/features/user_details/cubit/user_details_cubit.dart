import 'package:bloc/bloc.dart';
import 'package:move_university_project/features/user_details/data/models/user_details_model.dart';
import 'package:move_university_project/features/user_details/data/repositories/user_details_repository.dart';

import 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  final UserDetailsRepository _repository;

  UserDetailsCubit(this._repository) : super(const UserDetailsState.initial());

  // 유저 디테일 정보 가져오기
  Future<void> fetchUserDetails({String userName = ''}) async {
    emit(const UserDetailsState.loading());

    try {
      final userDetail = await _repository.fetchUserDetails(userName);
      emit(UserDetailsState.success(userDetail: userDetail));
    } catch (e, s) {
      emit(UserDetailsState.error(e: e, s: s));
    }
  }

  // 유저 정보 수정하기
  Future<void> updateUserDetails(UserDetailsModel userDetail) async {
    emit(const UserDetailsState.loading());

    try {
      await _repository.updateUserDetails(userDetail);
      emit(UserDetailsState.success(userDetail: userDetail));
    } catch (e, s) {
      emit(UserDetailsState.error(e: e, s: s));
    }
  }

  // 유저 정보 삭제하기
  Future<void> deleteUserDetails(String userName) async {
    emit(const UserDetailsState.loading());

    try {
      await _repository.deleteUserDetails(userName);
      emit(const UserDetailsState.initial());
    } catch (e, s) {
      emit(UserDetailsState.error(e: e, s: s));
    }
  }
}
