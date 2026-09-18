import '../../domain/entities/student.dart';

class StudentLocalDataSource {
  final List<Student> _students = [
    const Student(id: 1, studentId: 'STU-1001', fullName: 'Aarav Sharma', faculty: 'Computer Science', email: 'aarav@hsmss.edu', contactNo: '9800000001'),
    const Student(id: 2, studentId: 'STU-1002', fullName: 'Priya Karki', faculty: 'Business Studies', email: 'priya@hsmss.edu', contactNo: '9800000002'),
  ];
  int _nextId = 3;

  Future<List<Student>> getStudents({String query = ''}) async {
    if (query.isEmpty) return List.unmodifiable(_students);
    final lower = query.toLowerCase();
    return _students
        .where((s) => s.fullName.toLowerCase().contains(lower) || s.studentId.toLowerCase().contains(lower))
        .toList();
  }

  Future<void> addStudent(Student student) async {
    _students.add(Student(
      id: _nextId++,
      studentId: student.studentId,
      fullName: student.fullName,
      faculty: student.faculty,
      email: student.email,
      contactNo: student.contactNo,
    ));
  }

  Future<void> updateStudent(Student student) async {
    final index = _students.indexWhere((s) => s.id == student.id);
    if (index != -1) _students[index] = student;
  }

  Future<void> deleteStudent(int id) async {
    _students.removeWhere((s) => s.id == id);
  }
}
