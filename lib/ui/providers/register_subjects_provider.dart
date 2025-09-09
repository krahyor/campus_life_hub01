import 'dart:async';
import 'package:flutter/material.dart';
import '../service/register_subjects_service.dart';

class RegisteredSubjectsProvider extends ChangeNotifier {
  final RegistrationService _service = RegistrationService();

  String? _userId;
  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  List<Map<String, dynamic>> _subjects = [];
  List<Map<String, dynamic>> get subjects => _subjects;

  RegisteredSubjectsProvider();

  void loadRegisteredSubjects(String userId) {
    if (_userId == userId) return;

    _subscription?.cancel();
    _userId = userId;

    if (userId.isEmpty) {
      _subjects = [];
      notifyListeners();
      return;
    }

    _subscription = _service.getRegisteredSubjects(userId).listen((data) {
      _subjects = data;
      notifyListeners();
    });
  }

  Future<void> registerSubject(
    String subjectId,
    Map<String, dynamic> subjectData,
  ) async {
    if (_userId == null) return;
    await _service.registerSubject(_userId!, subjectId, subjectData);
  }

  Future<void> unregisterSubject(String subjectId) async {
    if (_userId == null) return;
    await _service.unregisterSubject(_userId!, subjectId);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
