
import 'package:flutter/cupertino.dart';

class EmptyEvaluationsView extends StatelessWidget {
  const EmptyEvaluationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No evaluations found.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Please create a new daily evaluation for this session.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}