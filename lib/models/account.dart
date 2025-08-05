enum Year { year1, year2, year3, year4 }

enum Faculty { computerEngineering, electricalEngineering, business, other }

class User {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final Year year;
  final String group;
  final int age;
  final Faculty faculty;
  final String role = "user";

  User({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.year,
    required this.group,
    required this.age,
    required this.faculty,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      year: Year.values[(json['year'] as int) - 1],
      group: json['group'],
      age: json['age'],
      faculty: json['faculty'],
    );
  }
}

extension FacultyDisplay on Faculty {
  String get displayName {
    switch (this) {
      case Faculty.computerEngineering:
        return 'วิศวกรรมคอมพิวเตอร์';
      case Faculty.electricalEngineering:
        return 'วิศวกรรมไฟฟ้า';
      case Faculty.business:
        return 'บริหารธุรกิจ';
      case Faculty.other:
        return 'อื่นๆ';
    }
  }
}
