import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/enrollment/enrollment_bloc.dart';
import '../../../bloc/enrollment/enrollment_event.dart';
import '../../../bloc/enrollment/enrollment_state.dart';
import '../../../data/model/attendance_record.dart';
import '../../../data/model/dto/class_attendance_dto.dart';
import '../global_widget/base_screen.dart';
import 'widget/student_attendane_card.dart';

class AttendanceScreen extends StatefulWidget {
  final String classId;
  final String? classSessionId;
  final String? startTime;
  final String? endTime;
  final String? date;
  final bool isEditMode;

  const AttendanceScreen({
    super.key,
    required this.classId,
    this.classSessionId,
    this.date,
    this.startTime,
    this.endTime,
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

    context.read<EnrollmentBloc>().add(
      FetchAttendanceRecords(classId: widget.classId, classSessionId: widget.classSessionId ?? ""),
    );
  }

  void _submitAttendance() {
    final bloc = context.read<EnrollmentBloc>();
    final state = bloc.state;

    final allStudentIds =
        state.enrollments!.map((e) => e.student.id).toSet();
    final markedStudentIds = state.attendanceRecords?.keys.toSet() ?? {};

    final unmarked = allStudentIds.difference(markedStudentIds);

    if (unmarked.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 8),
              Text('សូមបញ្ចូលស្ថានភាពចូលរួមសម្រាប់សិស្សទាំងអស់'),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    final records =
        state.attendanceRecords!.entries
            .map((e) => AttendanceRecord(studentId: e.key, status: e.value, classSessionId: widget.classSessionId ?? ""))
            .toList();

    final dto = ClassAttendanceDTO(
      classId: widget.classId,
      classSessionId: widget.classSessionId ?? "",
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
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text("អវត្តមានបានបញ្ចូលដោយជោគជ័យ!"),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.of(context).pop(true);
            });
          }

          if (state.status == EnrollmentStatus.patchedAttendance) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.update, color: Colors.white),
                    SizedBox(width: 8),
                    Text("អវត្តមានបានធ្វើបច្ចុប្បន្នភាពដោយជោគជ័យ"),
                  ],
                ),
                backgroundColor: Colors.blue,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                duration: const Duration(milliseconds: 1500),
              ),
            );
          }
        },
        child: Column(
          children: [
            // Enhanced Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade600, Colors.teal.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.how_to_reg,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'ការគ្រប់គ្រងអវត្ត',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (isUpdateMode)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'កែប្រែអវត្តមាន',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'កំណត់ត្រាអវត្តមានសម្រាប់ថ្នាក់ នៅថ្ងៃ ${widget.date}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Content Area
            Expanded(
              child: BlocBuilder<EnrollmentBloc, EnrollmentState>(
                builder: (context, state) {
                  if (state.status == EnrollmentStatus.loading) {
                    return Container(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Colors.teal.shade400,
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading student attendance...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state.enrollments == null || state.enrollments!.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Students Enrolled',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ពុំមានសិស្សដែលបានចុះឈ្មោះនៅក្នុងថ្នាក់នេះទេ។ សូមពិនិត្យថ្នាក់ឬបន្ថែមសិស្សថ្មី។',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  final hasMarkedAttendance =
                      state.attendanceRecords != null &&
                      state.attendanceRecords!.isNotEmpty;

                  final attendanceAlreadyExists =
                      state.attendanceAlreadyExists == true || hasSubmitted;

                  return Column(
                    children: [
                      // Statistics Card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.teal.shade50, Colors.teal.shade100],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.teal.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              icon: Icons.people,
                              label: 'Total Students',
                              value: state.enrollments!.length.toString(),
                              color: Colors.teal,
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.teal.shade200,
                            ),
                            _buildStatItem(
                              icon: Icons.check_circle,
                              label: 'Marked',
                              value:
                                  (state.attendanceRecords?.length ?? 0)
                                      .toString(),
                              color: Colors.green,
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.teal.shade200,
                            ),
                            _buildStatItem(
                              icon: Icons.pending,
                              label: 'Pending',
                              value:
                                  (state.enrollments!.length -
                                          (state.attendanceRecords?.length ??
                                              0))
                                      .toString(),
                              color: Colors.orange,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Student List
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            context.read<EnrollmentBloc>().add(
                              FetchEnrollmentsByClassId(widget.classId),
                            );

                            context.read<EnrollmentBloc>().add(
                              FetchAttendanceRecords(
                                classId: widget.classId,
                                classSessionId: widget.classSessionId ?? "",
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: state.enrollments!.length,
                              itemBuilder: (context, index) {
                                final enrollment = state.enrollments![index];
                                final student = enrollment.student;
                                final studentId = student.id;
                                final currentStatus =
                                    state.attendanceRecords?[studentId];

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: StudentAttendanceCard(
                                    fullName: student.getFullName,
                                    studentId: student.studentNumber,
                                    selectedStatus: _mapStringToStatus(
                                      currentStatus,
                                    ),
                                    onStatusChanged: (status) {
                                      if (attendanceAlreadyExists &&
                                          !isUpdateMode) {
                                        return;
                                      }

                                      if (status == null) {
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
                                      if (isUpdateMode &&
                                          attendanceAlreadyExists) {
                                        context.read<EnrollmentBloc>().add(
                                          PatchStudentAttendanceRecord(
                                            studentId: studentId,
                                            status: _mapStatusToString(status),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      // Bottom Action Area
                      Container(
                        padding: const EdgeInsets.all(16),

                        child: Column(
                          children: [
                            if (!attendanceAlreadyExists && hasMarkedAttendance)
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton.icon(
                                  onPressed:
                                      state.status ==
                                              EnrollmentStatus
                                                  .submittingAttendance
                                          ? null
                                          : _submitAttendance,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  icon:
                                      state.status ==
                                              EnrollmentStatus
                                                  .submittingAttendance
                                          ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                          : const Icon(Icons.send),
                                  label: Text(
                                    state.status ==
                                            EnrollmentStatus
                                                .submittingAttendance
                                        ? 'កំពុងបញ្ចូលអវត្តមាន...'
                                        : 'បញ្ចូលអវត្តមាន',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                            if (attendanceAlreadyExists)
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton.icon(
                                  onPressed: _toggleUpdateMode,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isUpdateMode
                                            ? Colors.orange
                                            : Colors.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  icon: Icon(
                                    isUpdateMode ? Icons.cancel : Icons.edit,
                                  ),
                                  label: Text(
                                    isUpdateMode
                                        ? 'ចាកចេញពីការកែប្រែ'
                                        : 'កែប្រែអវត្តមាន',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                            if (state.status ==
                                    EnrollmentStatus.attendanceError ||
                                state.status == EnrollmentStatus.patchingError)
                              Container(
                                margin: const EdgeInsets.only(top: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.red.shade200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error,
                                      color: Colors.red.shade600,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Error: ${state.errorMessage}',
                                        style: TextStyle(
                                          color: Colors.red.shade700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade700,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
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
