import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/class_session/class_session_bloc.dart';
import '../../../bloc/class_session/class_session_state.dart';
import '../../global_widget/section_header.dart';
import 'class_count_badge.dart';

class ScheduleSectionHeader extends StatelessWidget {
  final String currentDate;

  const ScheduleSectionHeader({super.key, required this.currentDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.indigo.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.class_, color: Colors.indigo, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: SectionHeader(title: "កាលវិភាគសំរាប់ $currentDate")),
        BlocBuilder<ClassSessionBloc, ClassSessionState>(
          builder: (context, state) {
            final classCount = state.classFilterByDate?.length ?? 0;
            return ClassCountBadge(count: classCount);
          },
        ),
      ],
    );
  }
}