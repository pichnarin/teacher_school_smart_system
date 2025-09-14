
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentAvatar extends StatelessWidget {
  final String firstName;
  final String lastName;

  const StudentAvatar({
    super.key,
    required this.firstName,
    required this.lastName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primary,
            theme.primary.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.all(2),
      child: CircleAvatar(
        radius: 26,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 24,
          backgroundColor: theme.primary.withValues(alpha: 0.1),
          child: Text(
            firstName[0].toUpperCase() + lastName[0].toUpperCase(),
            style: TextStyle(
              color: theme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}