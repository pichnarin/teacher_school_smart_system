import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Color? color;
  final VoidCallback? onSeeAll;
  final Text? buttonText;

  const SectionHeader({
    super.key,
    required this.title,
    this.color = Colors.black,
    this.onSeeAll,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: buttonText ?? const Text('See All', style: TextStyle(color: Colors.blue)),
          ),
      ],
    );
  }
}