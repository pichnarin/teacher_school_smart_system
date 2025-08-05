import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pat_asl_portal/screen/global_widget/base_screen.dart';
import 'package:pat_asl_portal/screen/report/student_report_screen.dart';
import 'package:pat_asl_portal/util/formatter/time_of_the_day_formater.dart';
import '../../../bloc/class/class_bloc.dart';
import '../../../bloc/class/class_event.dart';
import '../../../bloc/class/class_state.dart';
import '../../../data/model/class.dart';
import '../../../data/model/dto/score_dto.dart';
import '../../../util/helper_screen/state_screen.dart';
import '../home/widget/suggest_class_card.dart';
import '../navigator/navigator_controller.dart';
import 'exam_score_screen.dart';

enum KhmerMonth {
  january("មករា"),
  february("កម្ភៈ"),
  march("មីនា"),
  april("មេសា"),
  may("ឧសភា"),
  june("មិថុនា"),
  july("កក្កដា"),
  august("សីហា"),
  september("កញ្ញា"),
  october("តុលា"),
  november("វិច្ឆិកា"),
  december("ធ្នូ");

  final String khmer;
  const KhmerMonth(this.khmer);
}

class EvaluationScreen extends StatefulWidget {
  const EvaluationScreen({super.key});

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ClassBloc>().add(const FetchClasses());
  }

  final navigatorController = Get.find<NavigatorController>();

  // final List<int> _months = List.generate(12, (i) => i + 1);
  // final List<int> _years = List.generate(6, (i) => DateTime.now().year - 2 + i);
  //
  // String _getMonthName(int month) {
  //   if (month < 1 || month > 12)
  //     throw ArgumentError("Invalid month number: $month");
  //   return KhmerMonth.values[month - 1].khmer;
  // }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final color = theme.colorScheme;

    return BaseScreen(
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ClassBloc>().add(const FetchClasses());
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  SizedBox(
                    height: 220,

                    child: BlocBuilder<ClassBloc, ClassState>(
                      builder: (context, state) {
                        switch (state.status) {
                          case ClassStatus.loading:
                            return const LoadingState();

                          case ClassStatus.error:
                            return ErrorState(
                              errorMessage: state.errorMessage.toString(),
                            );

                          case ClassStatus.loaded:
                            final classes = state.classes;
                            if (classes == null || classes.isEmpty) {
                              return const EmptyState();
                            }
                            return _buildClassList(classes);

                          case ClassStatus.initial:
                            return const SizedBox();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassList(List<Class> classes) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: classes.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, index) {
        final session = classes[index];

        return SuggestedClassCard(
          classGrade: session.subjectLevel.name ?? 'N/A',
          classSubject: session.subject.subjectName,
          totalStudents: (session.studentCount ?? 0).toString(),
          onTap: () {
            navigatorController.pushToCurrentTab(
              ExamScoreScreen(
                classId: session.classId,
                subjectId: session.subject.subjectId,
                subjectName: session.subject.subjectName,
                subjectLevelId: session.subjectLevel.getId,
                subjectLevelName: session.subjectLevel.name ?? 'N/A',
              )

            );
          },
        );
      },
    );
  }
}
