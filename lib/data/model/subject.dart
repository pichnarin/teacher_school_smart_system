class Subject {
  final String subjectId;
  final String subjectName;

  const Subject({
    required this.subjectId,
    required this.subjectName,
  });

  String get getSubjectId => subjectId;
  String get getSubjectName => subjectName;

  @override
  String toString() {
    return 'Subject(subjectId: $subjectId, subjectName: $subjectName)';
  }
}



