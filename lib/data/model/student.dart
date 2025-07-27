class Student {
  final String id;
  final String studentNumber;
  final String firstName;
  final String lastName;
  final String grade;
  final DateTime dob;

  const Student({
    required this.id,
    required this.studentNumber,
    required this.firstName,
    required this.lastName,
    required this.grade,
    required this.dob,
  });

  String get getFullName => '$firstName $lastName';
  String get getId => id;



  @override
  String toString() => 'Student(id: $id, name: $getFullName, no: $studentNumber)';
}