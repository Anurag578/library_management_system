import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_student_use_case.dart';
import '../../../domain/usecases/delete_student_use_case.dart';
import '../../../domain/usecases/get_students_use_case.dart';
import '../../../domain/usecases/update_student_use_case.dart';
import 'student_event.dart';
import 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final GetStudentsUseCase getStudentsUseCase;
  final AddStudentUseCase addStudentUseCase;
  final UpdateStudentUseCase updateStudentUseCase;
  final DeleteStudentUseCase deleteStudentUseCase;

  StudentBloc({
    required this.getStudentsUseCase,
    required this.addStudentUseCase,
    required this.updateStudentUseCase,
    required this.deleteStudentUseCase,
  }) : super(const StudentState()) {
    on<StudentsRequested>(_onStudentsRequested);
    on<StudentAddRequested>(_onStudentAddRequested);
    on<StudentUpdateRequested>(_onStudentUpdateRequested);
    on<StudentDeleteRequested>(_onStudentDeleteRequested);
  }

  Future<void> _onStudentsRequested(StudentsRequested event, Emitter<StudentState> emit) async {
    emit(state.copyWith(status: StudentStatus.loading));
    try {
      final students = await getStudentsUseCase(query: event.query);
      emit(state.copyWith(status: StudentStatus.loaded, students: students));
    } catch (e) {
      emit(state.copyWith(status: StudentStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onStudentAddRequested(StudentAddRequested event, Emitter<StudentState> emit) async {
    await addStudentUseCase(event.student);
    add(const StudentsRequested());
  }

  Future<void> _onStudentUpdateRequested(StudentUpdateRequested event, Emitter<StudentState> emit) async {
    await updateStudentUseCase(event.student);
    add(const StudentsRequested());
  }

  Future<void> _onStudentDeleteRequested(StudentDeleteRequested event, Emitter<StudentState> emit) async {
    await deleteStudentUseCase(event.studentId);
    add(const StudentsRequested());
  }
}
