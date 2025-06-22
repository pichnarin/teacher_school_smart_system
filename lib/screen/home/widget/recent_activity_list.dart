import 'package:flutter/material.dart';

class RecentActivityList extends StatelessWidget {
  const RecentActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        5,
            (index) => ListTile(
          leading: const Icon(Icons.check_circle_outline),
          title: Text('Completed task #$index'),
          subtitle: const Text('Today • 2:00 PM'),
        ),
      ),
    );
  }
}