import 'package:equatable/equatable.dart';
import '../../../domain/entities/author.dart';

abstract class AuthorEvent extends Equatable {
  const AuthorEvent();
  @override
  List<Object?> get props => [];
}

class AuthorsRequested extends AuthorEvent {
  final String query;
  const AuthorsRequested({this.query = ''});
  @override
  List<Object?> get props => [query];
}

class AuthorAddRequested extends AuthorEvent {
  final Author author;
  const AuthorAddRequested(this.author);
  @override
  List<Object?> get props => [author.id];
}

class AuthorUpdateRequested extends AuthorEvent {
  final Author author;
  const AuthorUpdateRequested(this.author);
  @override
  List<Object?> get props => [author.id];
}

class AuthorDeleteRequested extends AuthorEvent {
  final int authorId;
  const AuthorDeleteRequested(this.authorId);
  @override
  List<Object?> get props => [authorId];
}
