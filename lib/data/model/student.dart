class Student {
  final String studentId;
  final String studentNumber;
  final String firstName;
  final String lastName;
  final String grade;
  final DateTime dob;

  const Student({
    required this.studentId,
    required this.studentNumber,
    required this.firstName,
    required this.lastName,
    required this.grade,
    required this.dob,
  });

  String get getFullName => '$firstName $lastName';



  @override
  String toString() => 'Student(id: $studentId, name: $getFullName, no: $studentNumber)';
}