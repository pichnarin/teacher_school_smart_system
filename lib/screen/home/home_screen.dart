import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pat_asl_portal/bloc/class/class_bloc.dart';
import 'package:pat_asl_portal/bloc/class/class_event.dart';
import 'package:pat_asl_portal/bloc/class/class_state.dart';
import 'package:pat_asl_portal/data/model/class.dart';
import 'package:pat_asl_portal/screen/global_widget/base_screen.dart';
import 'package:pat_asl_portal/screen/home/widget/news_card.dart';
import 'package:pat_asl_portal/screen/home/widget/recent_activity_list.dart';
import 'package:pat_asl_portal/screen/global_widget/section_header.dart';
import 'package:pat_asl_portal/screen/home/widget/suggest_class_card.dart';
import 'package:pat_asl_portal/screen/home/widget/welcum_banner.dart';
import 'package:pat_asl_portal/util/formatter/time_of_the_day_formater.dart';
import '../../util/checker/wifi_info.dart';
import '../navigator/navigator_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.find<NavigatorController>();
  @override
  void initState() {
    super.initState();
    //initial fetch
    context.read<ClassBloc>().add(const FetchClasses());
    // Future.delayed(Duration.zero, () {
    //   ensureLocationForWifi(context);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner
          WelcumBanner(
            greeting: Greeting.morning,
            teacherName: 'Mr. Narin Pich',
            amountOfTasks: '2',
          ),

          const SizedBox(height: 30),

          // Recent activity section
          SectionHeader(
            title: "Recent Activity",
          ),

          const SizedBox(height: 10),

          RecentActivityList(),

          const SizedBox(height: 30),

          // Suggested classes
          SectionHeader(
              title: "Suggested Classes",
            onSeeAll: (){
                controller.selectedIndex.value = 2; // Navigate to Schedule screen
            },
          ),

          const SizedBox(height: 10),

          // Class list with BlocBuilder
          SizedBox(
            height: 210,
            child: BlocBuilder<ClassBloc, ClassState>(
              builder: (context, state) {
                // debugPrint("HomeScreen ClassBloc State: ${state.status}, Classes: ${state.classes?.length}");
                switch (state.status) {
                  case ClassStatus.loading:
                    return const Center(child: CircularProgressIndicator());

                  case ClassStatus.error:
                    return Center(
                      child: Text(
                        'Error: ${state.errorMessage ?? "Something went wrong."}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );

                  case ClassStatus.loaded:
                    if (state.classes == null || state.classes!.isEmpty) {
                      return const Center(child: Text('No classes available'));
                    }
                    return _buildClassList(state.classes!);

                  case ClassStatus.initial:
                  return const SizedBox();
                }
              },
            ),
          ),

          const SizedBox(height: 30),

          // News
          SectionHeader(title: "News"),

          const SizedBox(height: 10),
          ...List.generate(
            5,
                (i) => NewsCard(
              title: 'New policy announcement',
              subtitle: 'Updated 5 minutes ago',
              onTap: () {
                // navigate to details
              },
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  /// Builds a horizontal list of suggested classes
  Widget _buildClassList(List<Class> classes) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: classes.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, index) {
        final classItem = classes[index];

        // Map Class model to SuggestedClassCard parameters
        return SuggestedClassCard(
          sessionType: classItem.schedule.getSessionName,
          classGrade: classItem.classGrade,
          classSubject: classItem.schedule.subject.subjectName,
          classDate: classItem.schedule.date,
          startTime: TimeFormatter.format(classItem.schedule.startTime),
          endTime: TimeFormatter.format(classItem.schedule.endTime),
          totalStudents: classItem.studentCount?.toString() ?? '0',
          // classItem.students?.length.toString(),
        );
      },
    );
  }

}