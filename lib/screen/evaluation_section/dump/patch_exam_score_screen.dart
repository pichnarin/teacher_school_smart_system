// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pat_asl_portal/bloc/exam_record/exam_record_bloc.dart';
// import 'package:pat_asl_portal/bloc/exam_record/exam_record_event.dart';
// import 'package:pat_asl_portal/data/model/score_with_student.dart';
//
// import '../../../data/model/dto/score_dto.dart';
//
// class PatchExamScoreScreen extends StatefulWidget {
//   final String classId;
//   final String subjectId;
//   final int examMonth;
//   final int examYear;
//   final List<ScoreWithStudent> existingScores;
//
//   const PatchExamScoreScreen({
//     super.key,
//     required this.classId,
//     required this.subjectId,
//     required this.examMonth,
//     required this.examYear,
//     required this.existingScores,
//   });
//
//   @override
//   State<PatchExamScoreScreen> createState() => _PatchExamScoreScreenState();
// }
//
// class _PatchExamScoreScreenState extends State<PatchExamScoreScreen> {
//   final Map<String, TextEditingController> _scoreControllers = {};
//   final Map<String, TextEditingController> _maxScoreControllers = {};
//   final Map<String, TextEditingController> _remarksControllers = {};
//
//   double? _parseDouble(String? text) =>
//       text == null || text.isEmpty ? null : double.tryParse(text);
//
//   @override
//   void initState() {
//     super.initState();
//     for (final s in widget.existingScores) {
//       _scoreControllers[s.student.studentId] = TextEditingController(
//         text: s.score.score.toString(),
//       );
//       _maxScoreControllers[s.student.studentId] = TextEditingController(
//         text: s.score.maxScore.toString(),
//       );
//       _remarksControllers[s.student.studentId] = TextEditingController(
//         text: s.score.remarks ?? '',
//       );
//     }
//   }
//
//
//   @override
//   void dispose() {
//     for (final controller in _scoreControllers.values) {
//       controller.dispose();
//     }
//     for (final controller in _maxScoreControllers.values) {
//       controller.dispose();
//     }
//     for (final controller in _remarksControllers.values) {
//       controller.dispose();
//     }
//     super.dispose();
//   }
//
//   void _onSubmit() {
//     final bloc = context.read<ExamRecordBloc>();
//     bool hasError = false;
//
//     for (final s in widget.existingScores) {
//       final studentId = s.student.studentId;
//       final scoreText = _scoreControllers[studentId]?.text.trim();
//       final maxText = _maxScoreControllers[studentId]?.text.trim();
//       final remarks = _remarksControllers[studentId]?.text.trim();
//
//       final score = _parseDouble(scoreText);
//       final maxScore = _parseDouble(maxText);
//
//       if (score == null || score < 0) {
//         hasError = true;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Invalid score for student $studentId')),
//         );
//         break;
//       }
//
//       bloc.add(
//         UpdateExamScore(
//           widget.classId,
//           s.score.scoreId,
//           UpdateScoreDto(
//             score: score,
//             maxScore: maxScore,
//             remarks: remarks?.isEmpty ?? true ? null : remarks,
//           ),
//         ),
//       );
//     }
//
//     if (!hasError) {
//       Navigator.pop(context);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Edit Exam Scores')),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: widget.existingScores.length,
//         itemBuilder: (context, index) {
//           final score = widget.existingScores[index];
//           final studentId = score.student.studentId;
//
//           final colorScheme = Theme.of(context).colorScheme;
//           final textTheme = Theme.of(context).textTheme;
//
//           return Card(
//             elevation: 1,
//             margin: const EdgeInsets.only(bottom: 16),
//             color: colorScheme.surfaceContainerHighest,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ListTile(
//                     contentPadding: EdgeInsets.zero,
//                     leading: CircleAvatar(
//                       backgroundColor: colorScheme.primaryContainer,
//                       child: Text(
//                         score.student.studentNumber,
//                         style: textTheme.labelLarge?.copyWith(
//                           color: colorScheme.onPrimaryContainer,
//                         ),
//                       ),
//                     ),
//                     title: Text(
//                       score.student.getFullName,
//                       style: textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.w600, color: Colors.black
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   TextField(
//                     controller: _scoreControllers[studentId],
//                     keyboardType: const TextInputType.numberWithOptions(
//                       decimal: true,
//                     ),
//                     decoration: InputDecoration(
//                       labelText: 'Score',
//                       filled: true,
//                       fillColor: colorScheme.surface,
//                       border: const OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(12)),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   TextField(
//                     controller: _maxScoreControllers[studentId],
//                     keyboardType: const TextInputType.numberWithOptions(
//                       decimal: true,
//                     ),
//                     decoration: InputDecoration(
//                       labelText: 'Max Score (optional)',
//                       filled: true,
//                       fillColor: colorScheme.surface,
//                       border: const OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(12)),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   TextField(
//                     controller: _remarksControllers[studentId],
//                     decoration: InputDecoration(
//                       labelText: 'Remarks (optional)',
//                       filled: true,
//                       fillColor: colorScheme.surface,
//                       border: const OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(12)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _onSubmit,
//         icon: const Icon(Icons.save),
//         label: const Text('Update Scores'),
//       ),
//     );
//   }
// }
