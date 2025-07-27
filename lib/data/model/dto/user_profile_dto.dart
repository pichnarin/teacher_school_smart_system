import 'package:intl/intl.dart';
import 'package:pat_asl_portal/data/model/user_profile.dart';

import '../../../util/formatter/time_of_the_day_formater.dart';

class UserProfileDTO {
  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final DateTime dob;
  final bool isSuspended;

  UserProfileDTO({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dob,
    required this.isSuspended,
  });

  factory UserProfileDTO.fromJson(Map<String, dynamic> json) {
    return UserProfileDTO(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['dob'] != null ? DateFormat('yyyy-MM-dd').parse(json['dob']) : DateTime(1970),
      isSuspended: json['is_suspended'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'dob': dob.toIso8601String(),
      'is_suspended': isSuspended,
    };
  }

  UserProfile toUserProfile() {
    return UserProfile(
      id: id,
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      dob: dob,
      isSuspended: isSuspended,
    );
  }

  static UserProfileDTO fromUserProfile(UserProfile userProfile) {
    return UserProfileDTO(
      id: userProfile.id,
      firstName: userProfile.firstName,
      lastName: userProfile.lastName,
      gender: userProfile.gender,
      dob: userProfile.dob,
      isSuspended: userProfile.isSuspended,
    );
  }


}
