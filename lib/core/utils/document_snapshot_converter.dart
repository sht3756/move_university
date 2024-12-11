import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class DocumentSnapshotConverter
    implements JsonConverter<DocumentSnapshot?, Map<String, dynamic>?> {
  const DocumentSnapshotConverter();

  @override
  DocumentSnapshot? fromJson(Map<String, dynamic>? json) {
    return null;
  }

  @override
  Map<String, dynamic>? toJson(DocumentSnapshot? snapshot) {
    return snapshot?.data() as Map<String, dynamic>?;
  }
}
