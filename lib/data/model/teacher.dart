import 'package:pat_asl_portal/data/model/user.dart';

class Teacher {
  final String teacherId;
  final String no;
  final User user;

  const Teacher({
    required this.teacherId,
    required this.no,
    required this.user,
  });

  String get getTeacherId => teacherId;
  String get getNo => no;
  String get getUserId => user.id;
}