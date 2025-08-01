import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../models/account.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserService {
  final _dbRef =
      FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: dotenv.env['FIREBASE_DB_URL'],
      ).ref();

  Future<void> saveUser(String uid, User userModel) async {
    await _dbRef.child('users/$uid').set({
      'email': userModel.email,
      'first_name': userModel.firstName,
      'last_name': userModel.lastName,
      'year': userModel.year.index + 1,
      'group': userModel.group,
      'age': userModel.age,
      'faculty':
          userModel.faculty == Faculty.computerEngineering
              ? 'วิศวกรรมคอมพิวเตอร์'
              : 'อื่นๆ',
    });
  }
}
