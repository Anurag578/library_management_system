import 'package:equatable/equatable.dart';
import '../../../domain/entities/author.dart';

enum AuthorStatus { initial, loading, loaded, error }

class AuthorState extends Equatable {
  final AuthorStatus status;
  final List<Author> authors;
  final String? errorMessage;

  const AuthorState({this.status = AuthorStatus.initial, this.authors = const [], this.errorMessage});

  AuthorState copyWith({AuthorStatus? status, List<Author>? authors, String? errorMessage}) {
    return AuthorState(
      status: status ?? this.status,
      authors: authors ?? this.authors,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, authors, errorMessage];
}
