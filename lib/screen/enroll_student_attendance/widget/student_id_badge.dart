
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentIdBadge extends StatelessWidget {
  final String id;

  const StudentIdBadge({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryContainer,
            theme.primaryContainer.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "ID: $id",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: theme.onPrimaryContainer,
        ),
      ),
    );
  }
}