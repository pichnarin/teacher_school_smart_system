import 'package:pat_asl_portal/data/model/student.dart';

import 'class_session.dart';

class DailyEvaluation{
  final String id;
  final Student student;
  final ClassSession classSession;
  final String homework;
  final String clothing;
  final String attitude;
  final int classActivity;
  final int overallScore;

  const DailyEvaluation({
    required this.id,
    required this.student,
    required this.classSession,
    required this.homework,
    required this.clothing,
    required this.attitude,
    required this.classActivity,
    required this.overallScore,
  });

  String get getId => id;
  Student get getStudent => student;
  ClassSession get getClassSession => classSession;
  String get getHomework => homework;
  String get getClothing => clothing;
  String get getAttitude => attitude;
  int get getClassActivity => classActivity;
  int get getOverallScore => overallScore;

  @override
  String toString() {
    return 'DailyEvaluation(id: $id, student: $student, classSession: $classSession, homework: $homework, clothing: $clothing, attitude: $attitude, classActivity: $classActivity, overallScore: $overallScore)';
  }

}