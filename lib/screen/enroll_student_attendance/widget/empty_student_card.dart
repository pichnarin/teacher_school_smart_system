
import 'package:flutter/material.dart';

class EmptyStudentCard extends StatelessWidget {
  const EmptyStudentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                color: Colors.amber.shade700,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                'មិនមានសិស្សចុះឈ្មោះទេ',
                style: TextStyle(
                  color: Colors.amber.shade700,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
