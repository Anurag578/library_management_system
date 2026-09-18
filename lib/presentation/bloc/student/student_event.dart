import 'package:equatable/equatable.dart';
import '../../../domain/entities/student.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();
  @override
  List<Object?> get props => [];
}

class StudentsRequested extends StudentEvent {
  final String query;
  const StudentsRequested({this.query = ''});
  @override
  List<Object?> get props => [query];
}

class StudentAddRequested extends StudentEvent {
  final Student student;
  const StudentAddRequested(this.student);
  @override
  List<Object?> get props => [student.id];
}

class StudentUpdateRequested extends StudentEvent {
  final Student student;
  const StudentUpdateRequested(this.student);
  @override
  List<Object?> get props => [student.id];
}

class StudentDeleteRequested extends StudentEvent {
  final int studentId;
  const StudentDeleteRequested(this.studentId);
  @override
  List<Object?> get props => [studentId];
}
