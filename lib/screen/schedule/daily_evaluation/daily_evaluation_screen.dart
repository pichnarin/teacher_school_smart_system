import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pat_asl_portal/bloc/daily_evaluation/daily_evaluation_event.dart';
import 'package:pat_asl_portal/screen/global_widget/base_screen.dart';

import '../../../bloc/daily_evaluation/daily_evaluation_bloc.dart';
import '../../../bloc/daily_evaluation/daily_evaluation_state.dart';
import '../../navigator/navigator_controller.dart';

class DailyEvaluationScreen extends StatefulWidget {
  final String classId;
  final String classSessionId;
  final String subjectId;
  final String subjectName;
  final String subjectLevelId;
  final String subjectLevelName;
  final String sessionDate;
  final String roomName;
  final String startTime;
  final String endTime;

  const DailyEvaluationScreen({
    super.key,
    required this.classId,
    required this.classSessionId,
    required this.subjectId,
    required this.subjectName,
    required this.subjectLevelId,
    required this.subjectLevelName,
    required this.sessionDate,
    required this.roomName, required this.startTime, required this.endTime,
  });

  @override
  State<DailyEvaluationScreen> createState() => _DailyEvaluationScreenState();
}

class _DailyEvaluationScreenState extends State<DailyEvaluationScreen> {
  final navigatorController = Get.find<NavigatorController>();

  @override
  void initState() {
    super.initState();
    context.read<DailyEvaluationBloc>().add(
      FetchDailyEvaluations(widget.classId, widget.sessionDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              context.read<DailyEvaluationBloc>().add(
                FetchDailyEvaluations(widget.classId, widget.sessionDate),
              );
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                BlocBuilder<DailyEvaluationBloc, DailyEvaluationState>(
                  builder: (context, state) {
                    if (state.status == DailyEvaluationStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.status == DailyEvaluationStatus.error) {
                      return Center(
                        child: Text(
                          'Error: ${state.errorMessage ?? "Unknown error"}',
                        ),
                      );
                    } else if (state.status == DailyEvaluationStatus.loaded &&
                        (state.dailyEvaluations?.isEmpty ?? true)) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'No evaluations found.',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Please create a new daily evaluation for this session.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    } else if (state.status == DailyEvaluationStatus.loaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Evaluations for (${widget.sessionDate} - ${widget.roomName} - ${widget.subjectName} - ${widget.subjectLevelName} - ${widget.startTime} - ${widget.endTime})',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          ...?state.dailyEvaluations?.map(
                            (evaluation) => ListTile(
                              title: Text(evaluation.student.studentNumber),
                              subtitle: Text(
                                'Score: ${evaluation.homework} - ${evaluation.attitude} - ${evaluation.clothing} - ${evaluation.classActivity}- ${evaluation.overallScore}',
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
