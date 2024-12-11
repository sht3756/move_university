import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:move_university_project/core/utils/stack_trace_converter.dart';
import 'package:move_university_project/features/user_details/data/models/user_details_model.dart';

part 'user_insert_state.freezed.dart';

part 'user_insert_state.g.dart';

@freezed
class UserInsertState with _$UserInsertState {
  const factory UserInsertState.initial() = _Initial;

  const factory UserInsertState.loading() = _Loading;

  const factory UserInsertState.success({
    required UserDetailsModel userDetail,
  }) = _Success;

  const factory UserInsertState.error({
    required Object e,
    @StackTraceConverter() required StackTrace s,
  }) = _Error;

  factory UserInsertState.fromJson(Map<String, dynamic> json) =>
      _$UserInsertStateFromJson(json);
}
