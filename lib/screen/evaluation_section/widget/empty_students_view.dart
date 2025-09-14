import 'package:flutter/material.dart';

class EmptyStudentsView extends StatelessWidget {
  const EmptyStudentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "No students found",
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}