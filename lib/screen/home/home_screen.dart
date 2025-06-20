import 'package:flutter/material.dart';
import 'package:pat_asl_portal/screen/global_widget/base_screen.dart';
import 'package:pat_asl_portal/screen/home/widget/section_header.dart';
import 'package:pat_asl_portal/screen/home/widget/welcum_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          ...List.generate(
            5,
            (index) => ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: Text('Completed task #$index'),
              subtitle: const Text('Today • 2:00 PM'),
            ),
          ),
          const SizedBox(height: 30),

          // Suggested classes
          const Text(
            'Suggested Classes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder:
                  (_, index) => Container(
                    width: 180,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Class ${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text('Instructor: Jane Doe'),
                      ],
                    ),
                  ),
            ),
          ),
          const SizedBox(height: 30),

          // News
          const Text(
            'Latest News',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...List.generate(
            5,
            (i) => Card(
              child: ListTile(
                leading: const Icon(Icons.newspaper),
                title: Text('News item ${i + 1}'),
                subtitle: const Text('Updated just now'),
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _quickAction({required IconData icon, required String label}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: Colors.blue.shade100,
          child: Icon(icon, color: Colors.blue, size: 28),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
