import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pat_asl_portal/bloc/class_session/class_session_event.dart';
import 'package:pat_asl_portal/data/model/class_session.dart';
import 'package:pat_asl_portal/data/model/session.dart';
import 'package:pat_asl_portal/screen/global_widget/base_screen.dart';
import 'package:pat_asl_portal/screen/global_widget/section_header.dart';
import 'package:pat_asl_portal/screen/schedule/widget/class_content_view.dart';
import 'package:pat_asl_portal/screen/schedule/widget/class_error_view.dart';
import 'package:pat_asl_portal/screen/schedule/widget/class_loading_view.dart';
import 'package:pat_asl_portal/screen/schedule/widget/date_picker.dart';
import 'package:pat_asl_portal/screen/schedule/widget/empty_class_view.dart';
import 'package:pat_asl_portal/screen/schedule/widget/empty_content_placeholder.dart';
import 'package:pat_asl_portal/screen/schedule/widget/schedule_date_picker.dart';
import 'package:pat_asl_portal/screen/schedule/widget/schedule_header.dart';
import 'package:pat_asl_portal/screen/schedule/widget/schedule_section_header.dart';
import '../../bloc/class_session/class_session_bloc.dart';
import '../../bloc/class_session/class_session_state.dart';
import '../../data/model/class.dart';
import '../../util/formatter/time_of_the_day_formater.dart';
import '../enroll_student_attendance/class_detail_screen.dart';
import '../home/widget/suggest_class_card.dart';
import '../navigator/navigator_controller.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final navigatorController = Get.find<NavigatorController>();
  final datePickerController = DatePickerController();

  late String currentDate;

  @override
  void initState() {
    super.initState();
    currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    context.read<ClassSessionBloc>().add(FetchClassSessionsByDate(currentDate));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ClassSessionBloc>().add(
            FetchClassSessionsByDate(currentDate),
          );
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ScheduleHeader(),

            const SizedBox(height: 24),

            ScheduleDatePicker(
              controller: datePickerController,
              onDateSelected: (date) {
                final formattedDate = datePickerController.formatDate();
                if (formattedDate != null) {
                  setState(() {
                    currentDate = formattedDate;
                  });
                  context.read<ClassSessionBloc>().add(
                    FetchClassSessionsByDate(formattedDate),
                  );
                }
              },
            ),

            const SizedBox(height: 24),

            ScheduleSectionHeader(currentDate: currentDate),

            const SizedBox(height: 16),

            BlocBuilder<ClassSessionBloc, ClassSessionState>(
              builder: (context, state) {
                switch (state.status) {
                  case ClassStatus.loading:
                    return ClassesLoadingView(currentDate: currentDate);

                  case ClassStatus.error:
                    return ClassesErrorView(errorMessage: state.errorMessage);

                  case ClassStatus.loaded:
                    if (state.classFilterByDate == null ||
                        state.classFilterByDate!.isEmpty) {
                      return EmptyClassesView(currentDate: currentDate);
                    }
                    return ClassesContentView(
                      classes: state.classFilterByDate!.cast<ClassSession>(),
                    );

                  default:
                    return const EmptyContentPlaceholder();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
























