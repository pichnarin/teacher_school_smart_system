
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AttendanceLoadingView extends StatelessWidget {
  const AttendanceLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.teal.shade400,
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading student attendance...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}