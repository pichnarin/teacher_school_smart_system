import '../student.dart';

class StudentDTO {
  final String id;
  final String studentNumber;
  final String firstName;
  final String lastName;
  final String grade;
  final DateTime dob;

  const StudentDTO({
    required this.id,
    required this.studentNumber,
    required this.firstName,
    required this.lastName,
    required this.grade,
    required this.dob
  });

  factory StudentDTO.fromJson(Map<String, dynamic> json) {
    return StudentDTO(
      id: json['id'] ?? '',
      studentNumber: json['no'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      grade: json['grade'] ?? '',
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : DateTime.now()
    );
  }

  Student toStudent() => Student(
    studentId: id,
    studentNumber: studentNumber,
    firstName: firstName,
    lastName: lastName,
    grade: grade,
    dob: dob
  );
}
