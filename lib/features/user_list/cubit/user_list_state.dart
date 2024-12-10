import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:move_university_project/core/utils/stack_trace_converter.dart';
import 'package:move_university_project/features/user_list/data/models/user_model.dart';

part 'user_list_state.freezed.dart';

part 'user_list_state.g.dart';

@freezed
class UserListState with _$UserListState {
  const factory UserListState.initial() = _Initial;
  const factory UserListState.loading() = _Loading;
  const factory UserListState.success({
    required List<UserModel> users,
    String? lastDocumentId,
    required bool hasMore,
}) = _Success;
  const factory UserListState.error({
      required Object e,
      @StackTraceConverter() required StackTrace s,
  }) =_Error;

  factory UserListState.fromJson(Map<String, dynamic> json) =>
      _$UserListStateFromJson(json);
}
