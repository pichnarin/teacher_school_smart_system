
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pat_asl_portal/screen/daily_evaluation/widget/empty_evaluation_value.dart';
import 'package:pat_asl_portal/screen/daily_evaluation/widget/error_message.dart';
import 'package:pat_asl_portal/screen/daily_evaluation/widget/evaluation_content.dart';
import 'package:pat_asl_portal/screen/daily_evaluation/widget/loading_indicator.dart';
import 'package:pat_asl_portal/screen/daily_evaluation/widget/session_info.dart';

import '../../bloc/daily_evaluation/daily_evaluation_bloc.dart';
import '../../bloc/daily_evaluation/daily_evaluation_event.dart';
import '../../bloc/daily_evaluation/daily_evaluation_state.dart';
import '../global_widget/base_screen.dart';
import '../navigator/navigator_controller.dart';

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
      required this.roomName,
      required this.startTime,
      required this.endTime,
    });

    @override
    State<DailyEvaluationScreen> createState() => _DailyEvaluationScreenState();
  }

  class _DailyEvaluationScreenState extends State<DailyEvaluationScreen> {
    final navigatorController = Get.find<NavigatorController>();

    @override
    void initState() {
      super.initState();
      _fetchEvaluations();
    }

    void _fetchEvaluations() {
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
                _fetchEvaluations();
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  BlocBuilder<DailyEvaluationBloc, DailyEvaluationState>(
                    builder: (context, state) {
                      if (state.status == DailyEvaluationStatus.loading) {
                        return const LoadingIndicator();
                      } else if (state.status == DailyEvaluationStatus.error) {
                        return ErrorMessage(message: state.errorMessage);
                      } else if (state.status == DailyEvaluationStatus.loaded &&
                          (state.dailyEvaluations?.isEmpty ?? true)) {
                        return const EmptyEvaluationsView();
                      } else if (state.status == DailyEvaluationStatus.loaded) {
                        return EvaluationsContent(
                          evaluations: state.dailyEvaluations!,
                          sessionInfo: SessionInfo(
                            date: widget.sessionDate,
                            roomName: widget.roomName,
                            subjectName: widget.subjectName,
                            subjectLevelName: widget.subjectLevelName,
                            startTime: widget.startTime,
                            endTime: widget.endTime,
                          ),
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
