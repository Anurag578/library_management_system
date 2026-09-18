import '../entities/student.dart';
import '../repositories/student_repository.dart';

class GetStudentsUseCase {
  final StudentRepository repository;
  GetStudentsUseCase(this.repository);

  Future<List<Student>> call({String query = ''}) => repository.getStudents(query: query);
}
