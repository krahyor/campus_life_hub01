import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserService {
  final _dbRef =
      FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: dotenv.env['FIREBASE_DB_URL'],
      ).ref();

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final snapshot = await _dbRef.child('users/$uid').get();
    if (!snapshot.exists) return null;
    return Map<String, dynamic>.from(snapshot.value as Map);
  }
}
