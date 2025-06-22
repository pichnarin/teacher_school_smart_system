
import 'package:pat_asl_portal/data/model/user_profile.dart';

class Teacher {
  final String teacherId;
  final String no;
  final UserProfile user;

  const Teacher({
    required this.teacherId,
    required this.no,
    required this.user,
  });

  String get getTeacherId => teacherId;
  String get getNo => no;
  String get getUserId => user.id;

  @override
  String toString() {
    return 'Teacher(teacherId: $teacherId, no: $no, user: $user)';
  }
}