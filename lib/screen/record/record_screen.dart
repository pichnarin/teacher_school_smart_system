import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pat_asl_portal/bloc/class_session/class_session_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/class_session/class_session_event.dart';
import '../../data/model/class.dart';
import '../global_widget/base_screen.dart';
import '../global_widget/quick_button_action.dart';
import '../global_widget/section_header.dart';
import '../navigator/navigator_controller.dart';

enum ReportType {
  monthly('ខែ'),
  yearly('ឆ្នាំ');

  final String khmer;
  const ReportType(this.khmer);

  static ReportType? fromString(String type) {
    switch (type.toLowerCase()) {
      case 'monthly':
        return ReportType.monthly;
      case 'yearly':
        return ReportType.yearly;
      default:
        return null;
    }
  }
}




class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final navigatorController = Get.find<NavigatorController>();

  @override
  void initState() {
    super.initState();
    context.read<ClassSessionBloc>().add(const FetchClassSessions());
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          debugPrint('Refreshing records...');
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 20),
            AttendanceSection(),
            const SizedBox(height: 20),
            ReportCardSection(),
            const SizedBox(height: 20),
            AttendanceReportSection(),
          ],
        ),
      ),
    );
  }
}

class AttendanceSection extends StatelessWidget {
  const AttendanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'កំណត់ត្រាអវត្តមាន'),
        const SizedBox(height: 10),
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                QuickActionButton(
                  icon: Icons.check_circle_outline,
                  title: 'កំណត់ត្រាអវត្តមានថ្ងៃនេះ',
                  subtitle: 'កំណត់ត្រាអវត្តមានសម្រាប់ថ្ងៃនេះ',
                  color: Colors.green,
                  onTap: () {
                    // TODO: Navigate to mark attendance
                  },
                ),
                const Divider(),
                QuickActionButton(
                  icon: Icons.edit,
                  title: 'កែប្រែអវត្តមានមុនៗ',
                  subtitle: 'កែប្រែកំណត់ត្រាអវត្តមានដែលបានកត់ត្រា',
                  color: Colors.orange,
                  onTap: () {
                    // TODO: Navigate to edit attendance
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ReportCardSection extends StatelessWidget {
  const ReportCardSection({super.key});

  void showReportOptionsDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('បង្កើតសញ្ញាបត្រប្រចាំ ${ReportType.fromString(type)?.khmer ?? type}'),
            content: Text('ជ្រើសរើសជម្រើសសម្រាប់បង្កើតសញ្ញាបត្រប្រចាំ ${ReportType.fromString(type)?.khmer ?? type}។'),
            actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ចាកចេញ'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to report card generation
            },
            child: const Text('បន្ត'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'បង្កើតសញ្ញាបត្រ'),
        const SizedBox(height: 10),
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                QuickActionButton(
                  icon: Icons.description,
                  title: 'សញ្ញាបត្រប្រចាំខែ',
                  subtitle: 'បង្កើតរបាយការណ៍សិក្សាប្រចាំខែ',
                  color: Colors.indigo,
                  onTap: () => showReportOptionsDialog(context, 'monthly'),
                ),
                const Divider(),
                QuickActionButton(
                  icon: Icons.book,
                  title: 'សញ្ញាបត្រប្រចាំឆ្នាំ',
                  subtitle: 'បង្កើតរបាយការណ៍សិក្សាពេញមួយឆ្នាំ',
                  color: Colors.teal,
                  onTap: () => showReportOptionsDialog(context, 'yearly'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AttendanceReportSection extends StatelessWidget {
  const AttendanceReportSection({super.key});

  void showAttendanceReportDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
        title: Text('$type Attendance Report'),
        content: Text('Generate ${ReportType.fromString(type)?.khmer ?? type} attendance report for students.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to attendance report
            },
            child: const Text('View Report'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'របាយការណ៍អវត្តមាន'),
        const SizedBox(height: 10),
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                QuickActionButton(
                  icon: Icons.calendar_month,
                  title: 'របាយការណ៍អវត្តមានប្រចាំខែ',
                  subtitle: 'មើលស្ថិតិអវត្តមានប្រចាំខែ',
                  color: Colors.cyan,
                  onTap: () => showAttendanceReportDialog(context, 'Monthly'),
                ),
                const Divider(),
                QuickActionButton(
                  icon: Icons.calendar_today,
                  title: 'របាយការណ៍អវត្តមានប្រចាំឆ្នាំ',
                  subtitle: 'បង្កើតសេចក្ដីសង្ខេបអវត្តមានប្រចាំឆ្នាំ',
                  color: Colors.amber,
                  onTap: () => showAttendanceReportDialog(context, 'Yearly'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

