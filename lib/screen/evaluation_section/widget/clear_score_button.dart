
import 'package:flutter/material.dart';

class ClearScoreButton extends StatelessWidget {
  final VoidCallback onClear;

  const ClearScoreButton({super.key, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilledButton.tonalIcon(
      style: FilledButton.styleFrom(
        minimumSize: const Size(40, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: colorScheme.errorContainer,
      ),
      icon: const Icon(Icons.clear, size: 20),
      onPressed: onClear,
      label: const SizedBox.shrink(),
    );
  }
}
