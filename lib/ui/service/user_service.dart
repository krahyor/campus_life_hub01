import '../../models/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> saveUser(String uid, User userModel) async {
    await users.doc(uid).set({
      'email': userModel.email,
      'first_name': userModel.firstName,
      'last_name': userModel.lastName,
      'year': userModel.year.index + 1,
      'group': userModel.group,
      'age': userModel.age,
      'role': 'user',
      'faculty':
          userModel.faculty == Faculty.computerEngineering
              ? 'วิศวกรรมคอมพิวเตอร์'
              : userModel.faculty == Faculty.electricalEngineering
              ? 'วิศวกรรมไฟฟ้า'
              : userModel.faculty == Faculty.business
              ? 'บริหารธุรกิจ'
              : 'อื่นๆ',
    });
  }
}
