import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  Future<List<UserModel>> fetchUsers({required int limit, String? lastDocumentId}) async {
    Query query = _firestore.collection('user').limit(limit);

    if (lastDocumentId != null) {
      query = query.startAfter([lastDocumentId]);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic> )).toList();
  }
}
