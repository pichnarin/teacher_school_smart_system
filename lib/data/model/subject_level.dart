import 'package:pat_asl_portal/data/model/subject.dart';

class SubjectLevel {
  final String id;
  final Subject subject;
  final String name;
  final int levelOrder;


  const SubjectLevel({
    required this.id,
    required this.subject,
    required this.name,
    required this.levelOrder,
  });

  String get getId => id;
  Subject get getSubject => subject;
  String get getName => name;
  int get getLevelOrder => levelOrder;

  @override
  String toString() {
    return 'Subject(id: $id, subject: $subject, name: $name, levelOrder: $levelOrder)';
  }
}



