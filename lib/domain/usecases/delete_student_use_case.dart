import '../repositories/student_repository.dart';

class DeleteStudentUseCase {
  final StudentRepository repository;
  DeleteStudentUseCase(this.repository);

  Future<void> call(int id) => repository.deleteStudent(id);
}
