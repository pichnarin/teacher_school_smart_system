import 'package:flutter/material.dart';

import '../../global_widget/section_header.dart';

class IconSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Text? buttonText;
  final VoidCallback? onSeeAll;

  const IconSectionHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    this.buttonText,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SectionHeader(
            title: title,
            buttonText: buttonText,
            onSeeAll: onSeeAll,
          ),
        ),
      ],
    );
  }
}