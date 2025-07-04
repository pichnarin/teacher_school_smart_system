import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/enrollment/enrollment_bloc.dart';
import '../../../bloc/enrollment/enrollment_event.dart';
import '../../../bloc/enrollment/enrollment_state.dart';
import '../../../data/model/attendance_record.dart';
import '../../../data/model/dto/class_attendance_dto.dart';
import '../../global_widget/base_screen.dart';
import 'widget/student_attendane_card.dart';

class AttendanceScreen extends StatefulWidget {
  final String classId;
  final String? date;
  final bool isEditMode;

  const AttendanceScreen({
    super.key,
    required this.classId,
    this.date,
    required this.isEditMode,
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool isUpdateMode = false;
  bool hasSubmitted = false;

  @override
  void initState() {
    super.initState();
    context.read<EnrollmentBloc>().add(
      FetchEnrollmentsByClassId(widget.classId),
    );

    // Always check for existing attendance records for today's date
    final dateToCheck =
        widget.date ?? DateTime.now().toIso8601String().split('T')[0];
    context.read<EnrollmentBloc>().add(
      FetchAttendanceRecords(classId: widget.classId, date: dateToCheck),
    );
  }

  void _submitAttendance() {
    final bloc = context.read<EnrollmentBloc>();
    final state = bloc.state;

    final allStudentIds =
        state.enrollments!.map((e) => e.student.studentId).toSet();
    final markedStudentIds = state.attendanceRecords?.keys.toSet() ?? {};

    final unmarked = allStudentIds.difference(markedStudentIds);

    if (unmarked.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please mark attendance for all students.'),
        ),
      );
      return;
    }

    final records =
        state.attendanceRecords!.entries
            .map((e) => AttendanceRecord(studentId: e.key, status: e.value))
            .toList();

    final dto = ClassAttendanceDTO(
      classId: widget.classId,
      date: DateTime.now(),
      attendanceRecords: records,
    );

    bloc.add(MarkAttendance(dto));
  }

  void _toggleUpdateMode() {
    setState(() => isUpdateMode = !isUpdateMode);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: BlocListener<EnrollmentBloc, EnrollmentState>(
        listener: (context, state) {
          if (state.status == EnrollmentStatus.attendanceSubmitted) {
            setState(() => hasSubmitted = true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Attendance submitted successfully."),
              ),
            );
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.of(context).pop(true);
            });
          }

          if (state.status == EnrollmentStatus.patchedAttendance) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Attendance updated successfully.")),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<EnrollmentBloc, EnrollmentState>(
            builder: (context, state) {
              if (state.status == EnrollmentStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.enrollments == null || state.enrollments!.isEmpty) {
                return const Center(child: Text('No students enrolled'));
              }

              final hasMarkedAttendance =
                  state.attendanceRecords != null &&
                  state.attendanceRecords!.isNotEmpty;

              // Check if attendance already exists in database OR was just submitted
              final attendanceAlreadyExists =
                  state.attendanceAlreadyExists == true || hasSubmitted;

              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<EnrollmentBloc>().add(
                          FetchEnrollmentsByClassId(widget.classId),
                        );

                        final dateToCheck =
                            widget.date ??
                            DateTime.now().toIso8601String().split('T')[0];
                        context.read<EnrollmentBloc>().add(
                          FetchAttendanceRecords(
                            classId: widget.classId,
                            date: dateToCheck,
                          ),
                        );
                      },
                      child: ListView.builder(
                        itemCount: state.enrollments!.length,
                        itemBuilder: (context, index) {
                          final enrollment = state.enrollments![index];
                          final student = enrollment.student;
                          final studentId = student.studentId;
                          final currentStatus =
                              state.attendanceRecords?[studentId];

                          return StudentAttendanceCard(
                            fullName: student.getFullName,
                            studentId: student.studentNumber,
                            selectedStatus: _mapStringToStatus(currentStatus),
                            onStatusChanged: (status) {
                              // Check if changes should be disabled
                              if (attendanceAlreadyExists && !isUpdateMode) {
                                return; // Do nothing if attendance exists and not in update mode
                              }

                              // Add null check before proceeding
                              if (status == null) {
                                // Remove the student from attendance records if deselected
                                final updatedRecords = {
                                  ...?state.attendanceRecords,
                                };
                                updatedRecords.remove(studentId);

                                context.read<EnrollmentBloc>().emit(
                                  state.copyWith(
                                    attendanceRecords: updatedRecords,
                                  ),
                                );
                                return;
                              }

                              final updatedRecords = {
                                ...?state.attendanceRecords,
                                studentId: _mapStatusToString(status),
                              };

                              context.read<EnrollmentBloc>().emit(
                                state.copyWith(
                                  attendanceRecords: updatedRecords,
                                ),
                              );

                              // Only patch if in update mode AND attendance already exists
                              if (isUpdateMode && attendanceAlreadyExists) {
                                // Get the attendance record ID from the attendanceRecordIds map
                                final attendanceRecordId =
                                    state.attendanceRecordIds?[studentId];
                                if (attendanceRecordId != null) {
                                  context.read<EnrollmentBloc>().add(
                                    PatchStudentAttendanceRecord(
                                      attendanceId: attendanceRecordId,
                                      status: _mapStatusToString(status),
                                    ),
                                  );
                                }
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Show submit button only if attendance doesn't exist yet AND has marked some attendance
                  if (!attendanceAlreadyExists && hasMarkedAttendance)
                    ElevatedButton(
                      onPressed:
                          state.status == EnrollmentStatus.submittingAttendance
                              ? null
                              : _submitAttendance,
                      child:
                          state.status == EnrollmentStatus.submittingAttendance
                              ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text("Submit Attendance"),
                    ),

                  // Show update toggle only if attendance already exists
                  if (attendanceAlreadyExists)
                    ElevatedButton.icon(
                      onPressed: _toggleUpdateMode,
                      icon: Icon(isUpdateMode ? Icons.cancel : Icons.edit),
                      label: Text(
                        isUpdateMode
                            ? 'Cancel Update Mode'
                            : 'Enter Update Mode',
                      ),
                    ),

                  if (state.status == EnrollmentStatus.attendanceError ||
                      state.status == EnrollmentStatus.patchingError)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Error: ${state.errorMessage}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  AttendanceStatus? _mapStringToStatus(String? status) {
    switch (status) {
      case 'present':
        return AttendanceStatus.present;
      case 'absent':
        return AttendanceStatus.absent;
      case 'late':
        return AttendanceStatus.late;
      default:
        return null;
    }
  }

  String _mapStatusToString(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return 'present';
      case AttendanceStatus.absent:
        return 'absent';
      case AttendanceStatus.late:
        return 'late';
    }
  }
}
