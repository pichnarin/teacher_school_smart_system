import '../teacher.dart';
import '../user.dart';

class TeacherDTO {
  final String teacherId;
  final String no;
  final User user;

  const TeacherDTO({
    required this.teacherId,
    required this.no,
    required this.user,
  });

  factory TeacherDTO.fromJson(Map<String, dynamic> json) {
    return TeacherDTO(
      teacherId: json['id'] ?? '',
      no: json['no'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teacherId': teacherId,
      'no': no,
      'user': user.toJson(),
    };
  }

  Teacher toTeacher() {
    return Teacher(
      teacherId: teacherId,
      no: no,
      user: user,
    );
  }

  static TeacherDTO fromTeacher(Teacher teacher) {
    return TeacherDTO(
      teacherId: teacher.teacherId,
      no: teacher.no,
      user: teacher.user,
    );
  }
}