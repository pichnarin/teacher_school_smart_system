import 'dart:convert';
import 'package:pat_asl_portal/data/model/dto/class_attendance_dto.dart';

import '../../util/exception/api_exception.dart';
import '../endpoint_collection.dart';
import '../model/checked_attendance_record.dart';
import '../model/dto/enrollment_dto.dart';
import '../model/dto/student_dto.dart';
import '../model/enrollment_with_student.dart';
import 'base_repository.dart';

class EnrollmentRepository {
  final BaseRepository _baseRepository;

  EnrollmentRepository({required BaseRepository baseRepository})
    : _baseRepository = baseRepository;

  Future<List<EnrollmentWithStudent>> fetchEnrollmentsByClassId(
    String classId,
  ) async {
    try {
      final url = EndpointCollection.studentListEndpoint(classId);
      final response = await _baseRepository.get(url);

      if (response.statusCode != 200) {
        final responseData = json.decode(response.body);
        throw ApiException(
          responseData is Map
              ? responseData['message'] ?? 'Failed to fetch enrollments'
              : 'Failed to fetch enrollments',
          response.statusCode,
        );
      }

      final List<dynamic> data = json.decode(response.body);
      List<EnrollmentWithStudent> result = [];

      for (var item in data) {
        try {
          // Create enrollment from root object data
          final enrollmentDTO = EnrollmentDTO(
            id: item['id'] ?? '',
            classId: classId, // Use the class ID passed to this method
            studentId: item['student']?['id'] ?? '',
          );

          // Create student from nested structure
          final studentData = item['student'];
          if (studentData == null) continue;

          final userData = studentData['user'];
          if (userData == null) continue;

          final studentDTO = StudentDTO(
            id: studentData['id'] ?? '',
            studentNumber: studentData['no'] ?? '',
            firstName: userData['first_name'] ?? '',
            lastName: userData['last_name'] ?? '',
            grade: item['class']?['grade'] ?? '',
            dob:
                userData['dob'] != null
                    ? DateTime.parse(userData['dob'])
                    : DateTime.now(),
          );

          result.add(
            EnrollmentWithStudent(
              enrollment: enrollmentDTO.toEnrollment(),
              student: studentDTO.toStudent(),
            ),
          );
        } catch (e) {
          print('Error parsing enrollment item: $e');
          // Continue to next item instead of failing entire request
        }
      }

      return result;
    } catch (e) {
      throw ApiException('Failed to fetch enrollments: $e', 500);
    }
  }

  Future<bool> markAttendance(ClassAttendanceDTO attendanceDTO) async {
    try {
      final url = EndpointCollection.markAttendanceEndpoint;

      final response = await _baseRepository.post(
        url,
        body: attendanceDTO.toJson(),
      );

      if (![200, 201].contains(response.statusCode)) {
        String message = 'Failed to mark attendance';
        try {
          final responseData = json.decode(response.body);
          if (responseData is Map && responseData['message'] != null) {
            message = responseData['message'];
          }
        } catch (_) {}
        throw ApiException(message, response.statusCode);
      }

      return true;
    } catch (e) {
      throw ApiException('Failed to mark attendance: $e', 500);
    }
  }

  Future<bool> patchAttendance(String attendanceId, String newStatus) async {
    try {
      final url = EndpointCollection.patchAttendanceEndpoint(attendanceId);

      final body = {
        'status': newStatus
      };

      final response = await _baseRepository.patch(url, body);

      if (![200, 204].contains(response.statusCode)) {
        String message = 'Failed to update attendance';
        try {
          final responseData = json.decode(response.body);
          if (responseData is Map && responseData['message'] != null) {
            message = responseData['message'];
          }
        } catch (_) {}
        throw ApiException(message, response.statusCode);
      }

      return true;
    } catch (e) {
      throw ApiException('Failed to update attendance: $e', 500);
    }
  }

  Future<List<CheckedAttendanceRecord>> getAttendanceByClassAndDate({
    required String classId,
    required String date,
  }) async {

    final uri = EndpointCollection.getAttendanceByClass(classId, date);

    final response = await _baseRepository.get(uri);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded.containsKey('records')) {
        final List records = decoded['records'];
        return records
            .map((e) => CheckedAttendanceRecord.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load attendance');
    }
  }

}
