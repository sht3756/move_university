import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_university_project/features/user_details/data/models/user_details_model.dart';

class UserDetailsRepository {
  final FirebaseFirestore _firestore;

  UserDetailsRepository(this._firestore);

  // 유저 디테일 정보 가져오기
  Future<UserDetailsModel> fetchUserDetails(String userEmail) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> document = await _firestore.collection('user').doc(userEmail).get();

      if(document.exists) {
        return UserDetailsModel.fromJson(document.data()!);
      } else {
        throw Exception('유저 Document 가 존재하지 않습니다.');
      }
    } catch(e, s) {
      throw Exception('fetchUserDetails-error : $e, $s');
    }
  }

  // 유저 정보 수정하기
  Future<void> updateUserDetails(UserDetailsModel userDetails) async {
    try {
      await _firestore.collection('user').doc(userDetails.email).update(userDetails.toJson());
    } catch(e, s) {
      throw Exception('updateUserDetails-error : $e, $s');
    }
  }

  // 유저 정보 삭제하기
  Future<void> deleteUserDetails(String userEmail) async {
    try {
      await _firestore.collection('user').doc(userEmail).delete();
    } catch(e, s){
      throw Exception('deleteUserDetails-error : $e, $s');
    }
  }
}