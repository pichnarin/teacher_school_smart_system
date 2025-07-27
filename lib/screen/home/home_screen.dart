import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pat_asl_portal/bloc/class/class_event.dart';
import 'package:pat_asl_portal/data/model/class.dart';
import 'package:pat_asl_portal/screen/global_widget/base_screen.dart';
import 'package:pat_asl_portal/screen/home/evaluation_section/evaluation_screen.dart';
import 'package:pat_asl_portal/screen/home/widget/news_card.dart';
import 'package:pat_asl_portal/screen/home/widget/recent_activity_list.dart';
import 'package:pat_asl_portal/screen/global_widget/section_header.dart';
import 'package:pat_asl_portal/screen/home/widget/suggest_class_card.dart';
import 'package:pat_asl_portal/screen/home/widget/welcum_banner.dart';
import 'package:pat_asl_portal/util/formatter/time_of_the_day_formater.dart';
import '../../bloc/class/class_bloc.dart';
import '../../bloc/class/class_state.dart';
import '../../data/model/class_session.dart';
import '../../util/checker/wifi_info.dart';
import '../../util/helper_screen/state_screen.dart';
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
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ClassBloc>().add(const FetchClasses());
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced Banner with gradient background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.blue.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: WelcumBanner(
                  greeting: Greeting.morning,
                  teacherName: 'Mr. Narin Pich',
                  amountOfTasks: '2',
                ),
              ),

              const SizedBox(height: 30),

              // Quick Actions Grid
              _buildQuickActionsGrid(),

              const SizedBox(height: 30),

              // Recent activity section with enhanced card
              SectionHeader(title: "សកម្មវិធីថ្មីៗ"),

              const SizedBox(height: 10),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: RecentActivityList(),
                ),
              ),

              const SizedBox(height: 30),

              // Suggested classes with enhanced header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SectionHeader(title: "ថ្នាក់សិក្សាដែលបានផ្តល់អនុសាសន៍"),
                  IconButton(
                    onPressed: () {
                      controller.selectedIndex.value = 2;
                    },
                    icon: const Icon(Icons.arrow_forward, size: 16),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Enhanced Class list with BlocBuilder
              SizedBox(
                height: 220,

                child: BlocBuilder<ClassBloc, ClassState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case ClassStatus.loading:
                        return const LoadingState();

                      case ClassStatus.error:
                        return ErrorState(errorMessage: state.errorMessage.toString());

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


              const SizedBox(height: 30),

              // Enhanced News section
              SectionHeader(title: "ការប្រកាសថ្មីៗ"),

              const SizedBox(height: 10),

              // News cards with enhanced styling
              ...List.generate(
                5,
                (i) => NewsCard(
                  title: 'ការប្រកាសថ្មីៗ',
                  subtitle: 'Updated 5 minutes ago',
                  onTap: () {
                    // navigate to details
                  },
                ),
                ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'សកម្មភាពលឿនៗ'),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            _buildQuickActionCard(
              icon: Icons.check_circle,
              title: 'កត់ត្រាអវត្តមាន',
              subtitle: 'ថ្នាក់សម្រាប់ថ្ងៃនេះ',
              color: Colors.green,
              onTap: () => controller.selectedIndex.value = 1,
            ),
            _buildQuickActionCard(
              icon: Icons.schedule,
              title: 'មើលកាលវិភាគ',
              subtitle: 'កាលវិភាគថ្នាក់',
              color: Colors.orange,
              onTap: () => controller.selectedIndex.value = 2,
            ),
            _buildQuickActionCard(
              icon: Icons.grade,
              title: 'ផ្នែកពិន្ទុប្រឡង',
              subtitle: 'លទ្ធផលប្រឡង',
              color: Colors.purple,
              onTap: () => controller.pushToCurrentTab(
                  EvaluationScreen()
              ),
            ),
            _buildQuickActionCard(
              icon: Icons.assessment,
              title: 'របាយការណ៍',
              subtitle: 'បង្កើតរបាយការណ៍',
              color: Colors.teal,
              onTap: () => controller.selectedIndex.value = 1,
            ),

          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
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
        final session = classes[index];

        return SuggestedClassCard(
          classGrade: session.subjectLevel.name.toUpperCase(),
          classSubject: session.subject.subjectName.toUpperCase(),
          totalStudents: (session.studentCount ?? 0).toString(),
        );
      },
    );
  }

}
