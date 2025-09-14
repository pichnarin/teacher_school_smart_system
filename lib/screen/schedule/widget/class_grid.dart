import 'package:flutter/cupertino.dart';

import '../../../data/model/class_session.dart';
import 'class_card.dart';

class ClassesGrid extends StatelessWidget {
  final List<ClassSession> classes;

  const ClassesGrid({super.key, required this.classes});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: classes.length,
      itemBuilder: (context, index) => ClassCard(classItem: classes[index]),
    );
  }
}