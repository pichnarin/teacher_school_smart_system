import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pat_asl_portal/screen/enroll_student_attendance/widget/attendance_content_view.dart';
import 'package:pat_asl_portal/screen/enroll_student_attendance/widget/attendance_header.dart';
import 'package:pat_asl_portal/screen/enroll_student_attendance/widget/attendance_loading_view.dart';
import 'package:pat_asl_portal/screen/enroll_student_attendance/widget/empty_enrollment_view.dart';
import '../../../bloc/enrollment/enrollment_bloc.dart';
import '../../../bloc/enrollment/enrollment_event.dart';
import '../../../bloc/enrollment/enrollment_state.dart';
import '../../../data/model/attendance_record.dart';
import '../../../data/model/dto/class_attendance_dto.dart';
import '../global_widget/base_screen.dart';
import 'widget/attendance_student_list.dart';
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
    _fetchData();
  }

  void _fetchData() {
    context.read<EnrollmentBloc>().add(
      FetchEnrollmentsByClassId(widget.classId),
    );

    context.read<EnrollmentBloc>().add(
      FetchAttendanceRecords(
        classId: widget.classId,
        classSessionId: widget.classSessionId ?? "",
      ),
    );
  }

  void _submitAttendance() {
    final bloc = context.read<EnrollmentBloc>();
    final state = bloc.state;

    final allStudentIds = state.enrollments!.map((e) => e.student.id).toSet();
    final markedStudentIds = state.attendanceRecords?.keys.toSet() ?? {};
    final unmarked = allStudentIds.difference(markedStudentIds);

    if (unmarked.isNotEmpty) {
      _showWarningSnackBar('សូមបញ្ចូលស្ថានភាពចូលរួមសម្រាប់សិស្សទាំងអស់');
      return;
    }

    final records =
        state.attendanceRecords!.entries
            .map(
              (e) => AttendanceRecord(
                studentId: e.key,
                status: e.value,
                classSessionId: widget.classSessionId ?? "",
              ),
            )
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

  void _showWarningSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: BlocListener<EnrollmentBloc, EnrollmentState>(
        listener: _handleStateChanges,
        child: Column(
          children: [
            AttendanceHeader(
              date: widget.date ?? '',
              isUpdateMode: isUpdateMode,
            ),
            Expanded(
              child: BlocBuilder<EnrollmentBloc, EnrollmentState>(
                builder: (context, state) {
                  if (state.status == EnrollmentStatus.loading) {
                    return const AttendanceLoadingView();
                  }

                  if (state.enrollments == null || state.enrollments!.isEmpty) {
                    return const EmptyEnrollmentView();
                  }

                  final hasMarkedAttendance =
                      state.attendanceRecords != null &&
                      state.attendanceRecords!.isNotEmpty;

                  final attendanceAlreadyExists =
                      state.attendanceAlreadyExists == true || hasSubmitted;

                  return AttendanceContentView(
                    enrollments: state.enrollments!,
                    attendanceRecords: state.attendanceRecords ?? {},
                    attendanceAlreadyExists: attendanceAlreadyExists,
                    hasMarkedAttendance: hasMarkedAttendance,
                    isUpdateMode: isUpdateMode,
                    enrollmentStatus: state.status,
                    onRefresh: _fetchData,
                    onSubmit: _submitAttendance,
                    onToggleUpdateMode: _toggleUpdateMode,
                    classId: widget.classId,
                    classSessionId: widget.classSessionId ?? "",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, EnrollmentState state) {
    if (state.status == EnrollmentStatus.attendanceSubmitted) {
      setState(() => hasSubmitted = true);
      _showSuccessSnackBar(
        "អវត្តមានបានបញ្ចូលដោយជោគជ័យ!",
        Icons.check_circle,
        Colors.green,
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop(true);
      });
    }

    if (state.status == EnrollmentStatus.patchedAttendance) {
      _showSuccessSnackBar(
        "អវត្តមានបានធ្វើបច្ចុប្បន្នភាពដោយជោគជ័យ",
        Icons.update,
        Colors.blue,
      );
    }
  }

  void _showSuccessSnackBar(String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }
}

// Extracted Widgets

