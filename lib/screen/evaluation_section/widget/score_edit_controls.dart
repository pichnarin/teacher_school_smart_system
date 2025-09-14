import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'clear_score_button.dart';

class ScoreEditControls extends StatelessWidget {
  final TextEditingController controller;
  final String scoreId;
  final Function(String, double) onPatchScore;
  final String? Function(String?) validateScore;

  const ScoreEditControls({
    super.key,
    required this.controller,
    required this.scoreId,
    required this.onPatchScore,
    required this.validateScore,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 140,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Edit',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
              ),
              onFieldSubmitted: (value) {
                final newScore = double.tryParse(value) ?? 0;
                onPatchScore(scoreId, newScore);
              },
              validator: validateScore,
            ),
          ),
          const SizedBox(width: 8),
          ClearScoreButton(
            onClear: () {
              controller.clear();
              onPatchScore(scoreId, 0);
            },
          ),
        ],
      ),
    );
  }
}
