import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pat_asl_portal/util/formatter/time_of_the_day_formater.dart';

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
      dob: TimeFormatter.safeParseDate(json['dob'] ?? '') ?? DateTime(1970),
    );
  }

  factory StudentDTO.fromStudent(Student student) {
    return StudentDTO(
      id: student.id,
      studentNumber: student.studentNumber,
      firstName: student.firstName,
      lastName: student.lastName,
      grade: student.grade,
      dob: student.dob
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'no': studentNumber,
      'first_name': firstName,
      'last_name': lastName,
      'grade': grade,
      'dob': dob.toIso8601String()
    };
  }



  Student toStudent() => Student(
      id: id,
    studentNumber: studentNumber,
    firstName: firstName,
    lastName: lastName,
    grade: grade,
    dob: dob
  );

  @override
  String toString() {
    return 'StudentDTO(id: $id, studentNumber: $studentNumber, firstName: $firstName, lastName: $lastName, grade: $grade, dob: $dob)';
  }
}
