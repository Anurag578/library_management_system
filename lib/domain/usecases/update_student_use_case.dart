import '../entities/student.dart';
import '../repositories/student_repository.dart';

class UpdateStudentUseCase {
  final StudentRepository repository;
  UpdateStudentUseCase(this.repository);

  Future<void> call(Student student) => repository.updateStudent(student);
}
