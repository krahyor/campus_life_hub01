import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerSubject(
    String userId,
    String subjectId,
    Map<String, dynamic> subjectData,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('registered_subjects')
        .doc(subjectId)
        .set(subjectData);
  }

  Future<void> unregisterSubject(String userId, String subjectId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('registered_subjects')
        .doc(subjectId)
        .delete();
  }

  Stream<List<Map<String, dynamic>>> getRegisteredSubjects(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('registered_subjects')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
