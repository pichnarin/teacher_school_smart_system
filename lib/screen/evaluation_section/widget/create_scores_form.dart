
import 'package:flutter/cupertino.dart';
import 'package:pat_asl_portal/screen/evaluation_section/widget/student_score_input_item.dart';

class CreateScoresForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<dynamic> students;
  final Function(String, String) onScoreChanged;
  final String? Function(String?) validateScore;

  const CreateScoresForm({
    super.key,
    required this.formKey,
    required this.students,
    required this.onScoreChanged,
    required this.validateScore,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index].student;
          return StudentScoreInputItem(
            student: student,
            onScoreChanged: (value) => onScoreChanged(student.id, value),
            validateScore: validateScore,
          );
        },
      ),
    );
  }
}