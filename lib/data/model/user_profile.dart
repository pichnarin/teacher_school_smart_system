class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final DateTime dob;
  final bool isSuspended;

  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dob,
    required this.isSuspended,
  });

  String get getFirstName => firstName;
  String get getLastName => lastName;
  String get getFullName => '$firstName $lastName';
  String get getId => id;
  String get getDob => '${dob.year}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}';
  String get getGender => gender;

  bool get getIsSuspended => isSuspended;

  @override
  String toString() {
    return 'UserProfile(id: $id, firstName: $firstName, lastName: $lastName, gender: $gender, dob: $dob, isSuspended: $isSuspended)';
  }

}
