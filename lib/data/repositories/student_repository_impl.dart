import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';
import '../datasources/student_local_data_source.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentLocalDataSource dataSource;
  StudentRepositoryImpl(this.dataSource);

  @override
  Future<List<Student>> getStudents({String query = ''}) => dataSource.getStudents(query: query);

  @override
  Future<void> addStudent(Student student) => dataSource.addStudent(student);

  @override
  Future<void> updateStudent(Student student) => dataSource.updateStudent(student);

  @override
  Future<void> deleteStudent(int id) => dataSource.deleteStudent(id);
}
