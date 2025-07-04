import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pat_asl_portal/bloc/enrollment/enrollment_event.dart';
import 'package:pat_asl_portal/bloc/enrollment/enrollment_state.dart';
import '../../data/service/enrollment_service.dart';

class EnrollmentBloc extends Bloc<EnrollmentEvent, EnrollmentState> {
  final EnrollmentService _enrollmentService;

  EnrollmentBloc({
    required EnrollmentService enrollmentService,
  })  : _enrollmentService = enrollmentService,
        super(const EnrollmentState()) {
    on<FetchEnrollmentsByClassId>(_onFetchEnrollmentsByClassId);
    on<MarkAttendance>(_onMarkAttendance);
    on<PatchStudentAttendanceRecord>(_onPatchStudentAttendance);
    on<FetchAttendanceRecords>(_onFetchAttendanceRecords);

  }

  void _onFetchEnrollmentsByClassId(
      FetchEnrollmentsByClassId event,
      Emitter<EnrollmentState> emit,
      ) async {
    emit(state.copyWith(status: EnrollmentStatus.loading));

    try {
      final enrollments = await _enrollmentService.getEnrollmentsByClassId(event.classId);
      debugPrint("Enrollments for class ${event.classId}: ${enrollments.length}");

      emit(state.copyWith(
        status: EnrollmentStatus.loaded,
        enrollments: enrollments,
        classId: event.classId,
      ));
    } catch (e) {
      debugPrint("Error fetching enrollments: $e");
      emit(state.copyWith(
        status: EnrollmentStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onMarkAttendance(
      MarkAttendance event,
      Emitter<EnrollmentState> emit,
      ) async {
    emit(state.copyWith(status: EnrollmentStatus.submittingAttendance));

    try {
      final result = await _enrollmentService.markAttendance(event.attendanceDTO);

      debugPrint("Attendance submission result: $result");

      if (result) {
        // Update local attendance records map
        final Map<String, String> updatedRecords = {...?state.attendanceRecords};

        for (var record in event.attendanceDTO.attendanceRecords) {
          updatedRecords[record.studentId] = record.status;
        }

        emit(state.copyWith(
          status: EnrollmentStatus.attendanceSubmitted,
          attendanceRecords: updatedRecords,
        ));
      } else {
        emit(state.copyWith(
          status: EnrollmentStatus.attendanceError,
          errorMessage: 'Failed to submit attendance',
        ));
      }
    } catch (e) {
      debugPrint("Error marking attendance: $e");
      emit(state.copyWith(
        status: EnrollmentStatus.attendanceError,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onPatchStudentAttendance(
      PatchStudentAttendanceRecord event,
      Emitter<EnrollmentState> emit,
      ) async {
    try {
      final updatedRecords = {...?state.attendanceRecords};
      updatedRecords[event.attendanceId] = event.status;

      emit(state.copyWith(
        status: EnrollmentStatus.patchingAttendance,
        attendanceRecords: updatedRecords,
      ));

      // Call the service to patch the status
      final result = await _enrollmentService.patchStudentAttendance(
        event.attendanceId,
        event.status,
      );

      if (result) {
        emit(state.copyWith(
          status: EnrollmentStatus.patchedAttendance,
        ));
      } else {
        emit(state.copyWith(
          status: EnrollmentStatus.patchingError,
          errorMessage: 'Failed to update attendance status',
        ));
      }
    } catch (e) {
      debugPrint("Error patching attendance: $e");
      emit(state.copyWith(
        status: EnrollmentStatus.patchingError,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onFetchAttendanceRecords(
      FetchAttendanceRecords event,
      Emitter<EnrollmentState> emit,
      ) async {
    emit(state.copyWith(status: EnrollmentStatus.loading));

    try {
      final records = await _enrollmentService.getAttendanceByClassAndDate(
        classId: event.classId,
        date: event.date,
      );

      final recordsMap = <String, String>{};
      final recordIdsMap = <String, String>{}; // NEW: Map studentId to attendance record ID

      for (var record in records) {
        recordsMap[record.studentId] = record.status;
        recordIdsMap[record.studentId] = record.id; // Store the actual attendance record ID
      }

      emit(state.copyWith(
        status: EnrollmentStatus.loaded,
        attendanceRecords: recordsMap,
        attendanceRecordIds: recordIdsMap, // NEW: Include the IDs map
        classId: event.classId,
        attendanceAlreadyExists: records.isNotEmpty,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EnrollmentStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }


}