import 'package:flutter/material.dart';

enum Greeting{
  morning('Good Morning'),
  afternoon('Good Afternoon'),
  evening('Good Evening');

  final String message;
  const Greeting(this.message);
}

class WelcumBanner extends StatelessWidget {
  final Greeting greeting;
  final String teacherName;
  final String amountOfTasks;

  const WelcumBanner({super.key,required this.greeting, required this.teacherName, required this.amountOfTasks});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.blueAccent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${greeting.message}, $teacherName 👋',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ថ្ងែនេះអ្នកមានថ្នាក់បង្រៀនចំនួន $amountOfTasks.',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
