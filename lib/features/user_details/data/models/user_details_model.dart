import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:move_university_project/core/utils/time_stamp_converter.dart';

part 'user_details_model.freezed.dart';

part 'user_details_model.g.dart';

@freezed
class UserDetailsModel with _$UserDetailsModel {
  factory UserDetailsModel({
    required String name,
    required String email,
    required String phone,
    @TimestampConverter() required DateTime registerDate,
    @TimestampConverter() required DateTime modifiedDate,
  }) = _UserDetailsModel;

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) => _$UserDetailsModelFromJson(json);
}
