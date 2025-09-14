
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pat_asl_portal/screen/enroll_student_attendance/widget/student_list.dart';

import '../../../bloc/enrollment/enrollment_bloc.dart';
import '../../../bloc/enrollment/enrollment_state.dart';
import 'empty_student_card.dart';
import 'error_student_card.dart';
import 'loading_student_card.dart';

class StudentListSection extends StatelessWidget {
  final String classId;

  const StudentListSection({
    super.key,
    required this.classId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EnrollmentBloc, EnrollmentState>(
      builder: (context, state) {
        if (state.status == EnrollmentStatus.loading) {
          return const LoadingStudentCard();
        } else if (state.status == EnrollmentStatus.error) {
          return ErrorStudentCard(errorMessage: state.errorMessage);
        } else if (state.enrollments != null && state.enrollments!.isNotEmpty) {
          return StudentList(students: state.enrollments!);
        }
        return const EmptyStudentCard();
      },
    );
  }
}
