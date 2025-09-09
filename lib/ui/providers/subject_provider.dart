import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/subject.dart';

class SubjectProvider with ChangeNotifier {
  List<Subject> _subjects = [];

  List<Subject> get subjects => _subjects;

  Future<void> loadSubjects() async {
    final String jsonString = await rootBundle.loadString(
      'assets/mock_subjects/mock_subjects.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    _subjects = jsonData.map((e) => Subject.fromJson(e)).toList();
    notifyListeners();
  }
}
