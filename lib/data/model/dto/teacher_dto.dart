import 'package:pat_asl_portal/data/model/dto/user_profile_dto.dart';

import '../teacher.dart';
import '../user_profile.dart';

class TeacherDTO {
  final String teacherId;
  final String no;
  final UserProfile user;

  const TeacherDTO({
    required this.teacherId,
    required this.no,
    required this.user,
  });

  factory TeacherDTO.fromJson(Map<String, dynamic> json) {
    try{
      return TeacherDTO(
        teacherId: json['id'] ?? '',
        no: json['no'] ?? '',
        user: UserProfileDTO.fromJson(json['user'] ?? {}).toUserProfile(),
      );
    }catch (e, stack) {
      print('❌ Failed to parse TeacherDTO: $e');
      print('🔍 Stack trace:\n$stack');
      print('🧪 Data:\n$json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'teacherId': teacherId,
      'no': no,
      'user': UserProfileDTO.fromUserProfile(user).toJson(),    };
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


