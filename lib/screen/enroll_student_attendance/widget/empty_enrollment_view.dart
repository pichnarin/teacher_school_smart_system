
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyEnrollmentView extends StatelessWidget {
  const EmptyEnrollmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Students Enrolled',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ពុំមានសិស្សដែលបានចុះឈ្មោះនៅក្នុងថ្នាក់នេះទេ។ សូមពិនិត្យថ្នាក់ឬបន្ថែមសិស្សថ្មី។',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
