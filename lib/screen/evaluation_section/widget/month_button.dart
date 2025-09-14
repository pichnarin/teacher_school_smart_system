
import 'dart:ui';

import 'package:flutter/material.dart';

class MonthButton extends StatelessWidget {
final String month;
final bool isSelected;
final VoidCallback onPressed;

const MonthButton({
super.key,
required this.month,
required this.isSelected,
required this.onPressed,
});

@override
Widget build(BuildContext context) {
final colorScheme = Theme.of(context).colorScheme;

return FilledButton.tonal(
style: FilledButton.styleFrom(
backgroundColor:
isSelected
? colorScheme.primary
    : colorScheme.surfaceContainerHighest,
foregroundColor:
isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
),
onPressed: onPressed,
child: Text(month, style: const TextStyle(fontWeight: FontWeight.bold)),
);
}
}