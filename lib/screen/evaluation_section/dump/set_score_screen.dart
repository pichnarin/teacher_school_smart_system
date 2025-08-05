// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pat_asl_portal/bloc/exam_record/exam_record_bloc.dart';
// import 'package:pat_asl_portal/bloc/exam_record/exam_record_event.dart';
// import 'package:pat_asl_portal/bloc/exam_record/exam_record_state.dart';
// import 'package:pat_asl_portal/data/model/dto/score_dto.dart';
//
// class SetExamScoreScreen extends StatefulWidget {
//   final String classId;
//   final String subjectId;
//   final int examMonth;
//   final int examYear;
//   final List<StudentScoreInput> initialScores;
//
//   const SetExamScoreScreen({
//     super.key,
//     required this.classId,
//     required this.subjectId,
//     required this.examMonth,
//     required this.examYear,
//     required this.initialScores,
//   });
//
//   @override
//   State<SetExamScoreScreen> createState() => _SetExamScoreScreenState();
// }
//
// class _SetExamScoreScreenState extends State<SetExamScoreScreen> {
//   bool _submitted = false;
//   late Map<String, TextEditingController> _scoreControllers;
//   late Map<String, TextEditingController> _maxScoreControllers;
//   late Map<String, TextEditingController> _remarksControllers;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _scoreControllers = {};
//     _maxScoreControllers = {};
//     _remarksControllers = {};
//
//     for (var s in widget.initialScores) {
//       _scoreControllers[s.studentId] = TextEditingController(
//         text: s.score.toString(),
//       );
//       _maxScoreControllers[s.studentId] = TextEditingController(
//         text: s.maxScore?.toString() ?? '',
//       );
//       _remarksControllers[s.studentId] = TextEditingController(
//         text: s.remarks ?? '',
//       );
//     }
//
//     // Dispatch CheckExamScoreSet event
//     context.read<ExamRecordBloc>().add(
//       CheckExamScoreSet(
//         widget.classId,
//         widget.subjectId,
//         widget.examMonth.toString().padLeft(2, '0'),
//         widget.examYear.toString(),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     for (var c in _scoreControllers.values) {
//       c.dispose();
//     }
//     for (var c in _maxScoreControllers.values) {
//       c.dispose();
//     }
//     for (var c in _remarksControllers.values) {
//       c.dispose();
//     }
//     super.dispose();
//   }
//
//   double? _parseDouble(String? text) {
//     if (text == null || text.isEmpty) return null;
//     return double.tryParse(text);
//   }
//
//   void _onSubmit() {
//     final studentScores = <StudentScoreInput>[];
//     bool hasError = false;
//
//     for (var studentId in _scoreControllers.keys) {
//       final scoreText = _scoreControllers[studentId]?.text.trim();
//       final maxScoreText = _maxScoreControllers[studentId]?.text.trim();
//       final remarksText = _remarksControllers[studentId]?.text.trim();
//
//       final score = _parseDouble(scoreText);
//       final maxScore = _parseDouble(maxScoreText);
//
//       if (score == null || score < 0) {
//         hasError = true;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'សូមបញ្ចូលពិន្ទុមិនអវិជ្ជមានដែលមានសុពលភាពសម្រាប់និស្សិត $studentId',
//             ),
//           ),
//         );
//         break;
//       }
//
//       if (maxScore != null && maxScore <= 0) {
//         hasError = true;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'ពិន្ទុអតិបរមាត្រូវតែវិជ្ជមានឬទទេសម្រាប់សិស្ស $studentId',
//             ),
//           ),
//         );
//         break;
//       }
//
//       studentScores.add(
//         StudentScoreInput(
//           studentId: studentId,
//           score: score,
//           maxScore: maxScore,
//           remarks: remarksText?.isEmpty == true ? null : remarksText,
//         ),
//       );
//     }
//
//     if (hasError) return;
//
//     final dto = SetExamScoresDto(
//       subjectId: widget.subjectId,
//       examMonth: widget.examMonth,
//       examYear: widget.examYear,
//       studentScores: studentScores,
//     );
//
//     setState(() {
//       _submitted = true;
//     });
//
//     context.read<ExamRecordBloc>().add(SetExamScores(widget.classId, dto));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Set Exam Scores')),
//       body: BlocConsumer<ExamRecordBloc, ExamRecordState>(
//         listener: (context, state) {
//           if (_submitted && state.status == ExamRecordStatus.loaded) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('បន្ទុកសម្រាប់ទិន្នន័យបានរក្សាទុក')),
//             );
//             Navigator.pop(context);
//           } else if (state.status == ExamRecordStatus.error) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Error: ${state.errorMessage}')),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state.scoreSetStatus == ExamScoreSetStatus.loading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (state.scoreSetStatus == ExamScoreSetStatus.error) {
//             return Center(child: Text('Error: ${state.scoreSetError}'));
//           }
//           if (state.scoreSetStatus == ExamScoreSetStatus.set) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text('បន្ទុកសម្រាប់ទិន្នន័យបានរក្សាទុករួចហើយ'),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Navigate to view or update scores
//                       Navigator.pop(context);
//                     },
//                     child: const Text('View/Update Scores'),
//                   ),
//                 ],
//               ),
//             );
//           }
//           if (state.status == ExamRecordStatus.loading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           // Only allow setting scores if notSet
//           if (state.scoreSetStatus == ExamScoreSetStatus.notSet) {
//             return ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: widget.initialScores.length,
//               itemBuilder: (context, index) {
//                 final studentScore = widget.initialScores[index];
//                 final studentId = studentScore.studentId;
//
//                 final colorScheme = Theme.of(context).colorScheme;
//                 final textTheme = Theme.of(context).textTheme;
//
//                 return Card(
//                   elevation: 1,
//                   margin: const EdgeInsets.only(bottom: 16),
//                   color: colorScheme.surfaceContainerHighest,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ListTile(
//                           contentPadding: EdgeInsets.zero,
//                           leading: CircleAvatar(
//                             backgroundColor: colorScheme.primaryContainer,
//                             child: Text(
//                               studentId,
//                               style: textTheme.labelLarge?.copyWith(
//                                 color: colorScheme.onPrimaryContainer,
//                               ),
//                             ),
//                           ),
//                           title: Text(
//                             'Student ID: $studentId',
//                             style: textTheme.titleMedium?.copyWith(
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         TextField(
//                           controller: _scoreControllers[studentId],
//                           keyboardType: const TextInputType.numberWithOptions(
//                             decimal: true,
//                           ),
//                           decoration: InputDecoration(
//                             labelText: 'Score',
//                             filled: true,
//                             fillColor: colorScheme.surface,
//                             border: const OutlineInputBorder(
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(12),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         TextField(
//                           controller: _maxScoreControllers[studentId],
//                           keyboardType: const TextInputType.numberWithOptions(
//                             decimal: true,
//                           ),
//                           decoration: InputDecoration(
//                             labelText: 'Max Score (optional)',
//                             filled: true,
//                             fillColor: colorScheme.surface,
//                             border: const OutlineInputBorder(
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(12),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         TextField(
//                           controller: _remarksControllers[studentId],
//                           keyboardType: TextInputType.text,
//                           decoration: InputDecoration(
//                             labelText: 'Remarks (optional)',
//                             filled: true,
//                             fillColor: colorScheme.surface,
//                             border: const OutlineInputBorder(
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(12),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//           // Default: nothing
//           return const SizedBox.shrink();
//         },
//       ),
//       floatingActionButton: BlocBuilder<ExamRecordBloc, ExamRecordState>(
//         builder: (context, state) {
//           return FloatingActionButton.extended(
//             onPressed:
//                 state.scoreSetStatus == ExamScoreSetStatus.notSet
//                     ? _onSubmit
//                     : null,
//             label: const Text('រក្សាទុកទិន្នន័យ'),
//             icon: const Icon(Icons.save),
//           );
//         },
//       ),
//     );
//   }
// }
