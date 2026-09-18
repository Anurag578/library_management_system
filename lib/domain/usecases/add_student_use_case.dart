import '../entities/student.dart';
import '../repositories/student_repository.dart';

class AddStudentUseCase {
  final StudentRepository repository;
  AddStudentUseCase(this.repository);

  Future<void> call(Student student) => repository.addStudent(student);
}
