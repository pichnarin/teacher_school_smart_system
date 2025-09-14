import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pat_asl_portal/bloc/exam_record/exam_record_event.dart';
import 'package:pat_asl_portal/data/model/dto/score_dto.dart';
import 'package:pat_asl_portal/screen/evaluation_section/widget/date_filter_selector.dart';
import 'package:pat_asl_portal/screen/evaluation_section/widget/exam_action_buttons.dart';
import 'package:pat_asl_portal/screen/evaluation_section/widget/exam_score_header.dart';
import 'package:pat_asl_portal/screen/evaluation_section/widget/khmer_months.dart';
import 'package:pat_asl_portal/screen/evaluation_section/widget/scores_content_section.dart';
import 'package:pat_asl_portal/screen/evaluation_section/widget/section_header_with_view_toggle.dart';
import 'package:pat_asl_portal/screen/global_widget/base_screen.dart';
import 'package:pat_asl_portal/util/helper_screen/state_screen.dart';
import '../../../bloc/exam_record/exam_record_bloc.dart';
import '../../../bloc/exam_record/exam_record_state.dart';
import '../navigator/navigator_controller.dart';
import '../report/student_report_screen.dart';
import 'create_or_patching_exam_score_screen.dart';

class ExamScoreScreen extends StatefulWidget {
  final String classId;
  final String subjectId;
  final String subjectName;
  final String subjectLevelId;
  final String subjectLevelName;
  const ExamScoreScreen({
    super.key,
    required this.classId,
    required this.subjectId,
    required this.subjectName,
    required this.subjectLevelId,
    required this.subjectLevelName,
  });

  @override
  State<ExamScoreScreen> createState() => _ExamScoreScreenState();
}

class _ExamScoreScreenState extends State<ExamScoreScreen> {
  final navigatorController = Get.find<NavigatorController>();
  late int examMonth;
  late int examYear;
  bool isGrid = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    examMonth = now.month;
    examYear = now.year;
    _fetchScores();
  }

  void _fetchScores() {
    context.read<ExamRecordBloc>().add(
      FetchExamScores(
        widget.classId,
        filter: GetExamScoresFilterDto(
          examMonth: examMonth,
          examYear: examYear,
          subjectId: widget.subjectId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final months = KhmerMonths.getMonthsList();
    final years = List.generate(5, (i) => DateTime.now().year - i);

    return BaseScreen(
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async => _fetchScores(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header
                ExamScoreHeader(
                  subjectName: widget.subjectName,
                  subjectLevelName: widget.subjectLevelName,
                ),
                const SizedBox(height: 24),

                // Month & Year Picker
                DateFilterSelector(
                  months: months,
                  years: years,
                  selectedMonth: examMonth,
                  selectedYear: examYear,
                  onMonthChanged: (month) {
                    setState(() {
                      examMonth = month;
                      _fetchScores();
                    });
                  },
                  onYearChanged: (year) {
                    setState(() {
                      examYear = year;
                      _fetchScores();
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Section Header & Scores
                SectionHeaderWithViewToggle(
                  title: "បន្ទុះសំរាប់ខែ ${months[examMonth - 1]}",
                  isGrid: isGrid,
                  onToggleView: () {
                    setState(() {
                      isGrid = !isGrid;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Scores Content
                ScoresContentSection(
                  examMonth: examMonth,
                  examYear: examYear,
                  months: months,
                  isGrid: isGrid,
                  navigatorController: navigatorController,
                  classId: widget.classId,
                  subjectId: widget.subjectId,
                  subjectName: widget.subjectName,
                  subjectLevelId: widget.subjectLevelId,
                  subjectLevelName: widget.subjectLevelName,
                ),
              ],
            ),
          ),

          // Floating Action Buttons
          ExamActionButtons(
            examMonth: examMonth,
            examYear: examYear,
            classId: widget.classId,
            subjectId: widget.subjectId,
            subjectName: widget.subjectName,
            subjectLevelId: widget.subjectLevelId,
            subjectLevelName: widget.subjectLevelName,
            navigatorController: navigatorController,
          ),
        ],
      ),
    );
  }
}






























