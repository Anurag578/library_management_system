import '../entities/student.dart';

abstract class StudentRepository {
  Future<List<Student>> getStudents({String query = ''});
  Future<void> addStudent(Student student);
  Future<void> updateStudent(Student student);
  Future<void> deleteStudent(int id);
}
