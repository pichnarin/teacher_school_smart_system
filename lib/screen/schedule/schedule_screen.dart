import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pat_asl_portal/bloc/class/class_event.dart';
import 'package:pat_asl_portal/screen/global_widget/base_screen.dart';
import 'package:pat_asl_portal/screen/global_widget/section_header.dart';
import 'package:pat_asl_portal/screen/schedule/widget/date_picker.dart';
import '../../bloc/class/class_bloc.dart';
import '../../bloc/class/class_state.dart';
import '../../data/model/class.dart';
import '../../util/formatter/time_of_the_day_formater.dart';
import '../enroll_student_attendance/attendance_screen.dart';
import '../home/widget/suggest_class_card.dart';
import '../navigator/navigator_controller.dart';

//when user click on schedule, it will show the schedule screen
// this screen will show the schedule of the user like classes, exams, and other activities
//classes for today, classes for tomorrow, classes for this week, classes for next week: first priority
//user can set exam schedule for a class and notification for parent

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final navigatorController = Get.find<NavigatorController>();
  final datePickerController = DatePickerController();

  //parameter to fetch classes by date
  late String currentDate;

  @override
  void initState() {
    super.initState();
    //initialize the date to today
    currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // Fetch classes when the screen loads
    context.read<ClassBloc>().add(FetchClassesByDate(currentDate));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          //date picker widget
          GestureDatePicker(
            controller: datePickerController,
            onDateSelected: (date) {
              // Handle date selection
              final formattedDate = datePickerController.formatDate();

              if (formattedDate != null) {
                setState(() {
                  currentDate = formattedDate;
                });

                // Fetch classes for the selected date
                context.read<ClassBloc>().add(
                  FetchClassesByDate(formattedDate),
                );
                debugPrint("Selected date: $date (formatted: $formattedDate)");
              }
            },
          ),

          SectionHeader(title: "Your Schedule"),

          const SizedBox(height: 10),

          // Class list with BlocBuilder
          BlocBuilder<ClassBloc, ClassState>(
            builder: (context, state) {
              debugPrint(
                "ScheduleScreen ClassBloc State: ${state.status}, Classes: ${state.classFilterByDate?.length}, Date: $currentDate",
              );
              switch (state.status) {
                case ClassStatus.loading:
                  return const Center(child: CircularProgressIndicator());

                case ClassStatus.error:
                  return Center(
                    child: Text(
                      'Error: ${state.errorMessage ?? "Failed to load classes"}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );

                case ClassStatus.loaded:
                  if (state.classFilterByDate == null || state.classFilterByDate!.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No classes scheduled for this date'),
                      ),
                    );
                  }
                  return _buildClassList(state.classFilterByDate!);

                default:
                  return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClassList(List<Class> classes) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final classItem = classes[index];

        return SuggestedClassCard(
          sessionType: classItem.schedule.getSessionName,
          classGrade: classItem.classGrade,
          classSubject: classItem.schedule.subject.subjectName,
          classDate: classItem.schedule.date,
          startTime: TimeFormatter.format(classItem.schedule.startTime),
          endTime: TimeFormatter.format(classItem.schedule.endTime),
          totalStudents: "10",
          onTap: () {
            // Navigate to class details
          },
        );
      },
    );
  }
}

//Center(
//       child: ElevatedButton(
//         onPressed: () {
//           final nav = controller.navigatorKeys[2].currentState;
//           if (nav != null) {
//             nav.push(MaterialPageRoute(builder: (_) => AttendanceScreen()));
//           } else {
//             debugPrint("Navigator not ready yet");
//           }
//         },
//         child: Text("Take Attendance"),
//       ),
//       ),
