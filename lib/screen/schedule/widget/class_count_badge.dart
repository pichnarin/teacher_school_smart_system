import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassCountBadge extends StatelessWidget {
  final int count;

  const ClassCountBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.indigo.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count ថ្នាក់',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.indigo,
        ),
      ),
    );
  }
}