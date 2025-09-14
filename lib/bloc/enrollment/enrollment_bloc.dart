import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pat_asl_portal/bloc/enrollment/enrollment_event.dart';
import 'package:pat_asl_portal/bloc/enrollment/enrollment_state.dart';
import '../../data/service/enrollment_service.dart';

class EnrollmentBloc extends Bloc<EnrollmentEvent, EnrollmentState> {
  final EnrollmentService _enrollmentService;

  EnrollmentBloc({required EnrollmentService enrollmentService})
    : _enrollmentService = enrollmentService,
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
      final enrollments = await _enrollmentService.getEnrollmentsByClassId(
        event.classId,
      );
      debugPrint(
        "Enrollments for class ${event.classId}: ${enrollments.length}",
      );

      emit(
        state.copyWith(
          status: EnrollmentStatus.loaded,
          enrollments: enrollments,
          classId: event.classId,
        ),
      );
    } catch (e) {
      debugPrint("Error fetching enrollments: $e");
      emit(
        state.copyWith(
          status: EnrollmentStatus.error,
          errorMessage: e.toString(),
          enrollments: state.enrollments, //  Preserve previous
        ),
      );
    }
  }

  void _onMarkAttendance(
    MarkAttendance event,
    Emitter<EnrollmentState> emit,
  ) async {
    emit(state.copyWith(status: EnrollmentStatus.submittingAttendance));

    try {
      final result = await _enrollmentService.markAttendance(
        event.attendanceDTO,
      );

      if (result) {
        // Update local attendance records map
        final Map<String, String> updatedRecords = {
          ...?state.attendanceRecords,
        };

        for (var record in event.attendanceDTO.attendanceRecords) {
          updatedRecords[record.studentId] = record.status;
        }

        emit(
          state.copyWith(
            status: EnrollmentStatus.attendanceSubmitted,
            attendanceRecords: updatedRecords,
            attendanceAlreadyExists: true,
            enrollments: state.enrollments, //  Preserve on success
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: EnrollmentStatus.attendanceError,
            errorMessage: 'Failed to submit attendance',
            enrollments: state.enrollments, // Preserve on failure
          ),
        );
      }
    } catch (e) {
      debugPrint("Error marking attendance: $e");
      emit(
        state.copyWith(
          status: EnrollmentStatus.attendanceError,
          errorMessage: e.toString(),
          enrollments: state.enrollments, //  Preserve on failure
        ),
      );
    }
  }

  void _onPatchStudentAttendance(
    PatchStudentAttendanceRecord event,
    Emitter<EnrollmentState> emit,
  ) async {
    try {
      final attendanceRecordId = state.attendanceRecordIds?[event.studentId];

      if (attendanceRecordId == null) {
        emit(
          state.copyWith(
            status: EnrollmentStatus.patchingError,
            errorMessage: 'Attendance exam_record ID not found for student',
            enrollments: state.enrollments, //  Preserve
          ),
        );
        return;
      }

      final updatedRecords = {...?state.attendanceRecords};
      updatedRecords[event.studentId] = event.status;

      emit(
        state.copyWith(
          status: EnrollmentStatus.patchingAttendance,
          attendanceRecords: updatedRecords,
          enrollments: state.enrollments, //  Preserve
        ),
      );

      final result = await _enrollmentService.patchStudentAttendance(
        attendanceRecordId,
        event.status,
      );

      if (result) {
        emit(
          state.copyWith(
            status: EnrollmentStatus.loaded,
            enrollments: state.enrollments, //  Preserve
          ),
        );
      } else {
        final revertedRecords = {...?state.attendanceRecords};
        revertedRecords.remove(event.studentId);

        emit(
          state.copyWith(
            status: EnrollmentStatus.patchingError,
            errorMessage: 'Failed to update attendance status',
            attendanceRecords: revertedRecords,
            enrollments: state.enrollments, //  Preserve
          ),
        );
      }
    } catch (e) {
      debugPrint("Error patching attendance: $e");
      emit(
        state.copyWith(
          status: EnrollmentStatus.patchingError,
          errorMessage: e.toString(),
          enrollments: state.enrollments, //  Preserve
        ),
      );
    }
  }

  void _onFetchAttendanceRecords(
    FetchAttendanceRecords event,
    Emitter<EnrollmentState> emit,
  ) async {
    try {
      final records = await _enrollmentService.getAttendanceByClassSession(
        classId: event.classId,
        classSessionId: event.classSessionId,
      );

      final recordsMap = <String, String>{};
      final recordIdsMap = <String, String>{};

      for (var record in records) {
        if (record.id != null) {
          recordsMap[record.studentId] = record.status;
          recordIdsMap[record.studentId] = record.id;
        }
      }

      emit(
        state.copyWith(
          status: EnrollmentStatus.loaded,
          attendanceRecords: recordsMap,
          attendanceRecordIds: recordIdsMap,
          classId: event.classId,
          attendanceAlreadyExists: records.isNotEmpty,
          enrollments: state.enrollments, //  Preserve
        ),
      );
    } catch (e) {
      debugPrint("Error fetching attendance records: $e");
      emit(
        state.copyWith(
          status: EnrollmentStatus.error,
          errorMessage: e.toString(),
          enrollments: state.enrollments, //  Preserve
        ),
      );
    }
  }
}
