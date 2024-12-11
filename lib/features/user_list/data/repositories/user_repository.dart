import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  Future<Map<String, dynamic>> fetchUsers(
      {required int limit, DocumentSnapshot? lastDocumentId}) async {
    Query query = _firestore
        .collection('user')
        .orderBy('registerDate', descending: true)
        .limit(limit);

    if (lastDocumentId != null) {
      query = query.startAfterDocument(lastDocumentId);
    }

    final snapshot = await query.get();
    return {
      'users': snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList(),
      'lastDocument': snapshot.docs.isEmpty ? null : snapshot.docs.last,
    };
  }
}
