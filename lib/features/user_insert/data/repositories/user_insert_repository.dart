import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_university_project/features/user_details/data/models/user_details_model.dart';

class UserInsertRepository {
  final FirebaseFirestore _firestore;
  UserInsertRepository(this._firestore);

  // 유저 정보 등록
  Future<void> insertUserDetails(UserDetailsModel userDetail) async {
    try {
      await _firestore.collection('user').doc(userDetail.email).set(userDetail.toJson());

    } catch(e, s) {
      throw Exception('insertUserDetails-error : $e, $s');
    }
  }
}