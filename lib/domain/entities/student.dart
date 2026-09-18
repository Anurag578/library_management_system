class Student {
  final int id;
  final String studentId;
  final String fullName;
  final String faculty;
  final String email;
  final String contactNo;

  const Student({
    required this.id,
    required this.studentId,
    required this.fullName,
    required this.faculty,
    required this.email,
    required this.contactNo,
  });

  Student copyWith({
    String? studentId,
    String? fullName,
    String? faculty,
    String? email,
    String? contactNo,
  }) {
    return Student(
      id: id,
      studentId: studentId ?? this.studentId,
      fullName: fullName ?? this.fullName,
      faculty: faculty ?? this.faculty,
      email: email ?? this.email,
      contactNo: contactNo ?? this.contactNo,
    );
  }
}
