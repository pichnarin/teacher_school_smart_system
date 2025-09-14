import 'package:flutter/cupertino.dart';

import '../../../data/model/class_session.dart';
import 'class_grid.dart';
import 'class_summart_stat.dart';

class ClassesContentView extends StatelessWidget {
  final List<ClassSession> classes;

  const ClassesContentView({super.key, required this.classes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClassesSummaryStats(classes: classes),
        const SizedBox(height: 16),
        ClassesGrid(classes: classes),
      ],
    );
  }
}