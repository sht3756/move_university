import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:move_university_project/core/utils/stack_trace_converter.dart';
import 'package:move_university_project/features/user_details/data/models/user_details_model.dart';

part 'user_details_state.freezed.dart';

part 'user_details_state.g.dart';

@freezed
class UserDetailsState with _$UserDetailsState {
  const factory UserDetailsState.initial() = _Initial;

  const factory UserDetailsState.loading() = _Loading;

  const factory UserDetailsState.success({
    required UserDetailsModel userDetail,
  }) = _Success;

  const factory UserDetailsState.error({
    required Object e,
    @StackTraceConverter() required StackTrace s,
  }) = _Error;

  factory UserDetailsState.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsStateFromJson(json);
}
