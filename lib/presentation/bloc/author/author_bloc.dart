import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_author_use_case.dart';
import '../../../domain/usecases/delete_author_use_case.dart';
import '../../../domain/usecases/get_authors_use_case.dart';
import '../../../domain/usecases/update_author_use_case.dart';
import 'author_event.dart';
import 'author_state.dart';

class AuthorBloc extends Bloc<AuthorEvent, AuthorState> {
  final GetAuthorsUseCase getAuthorsUseCase;
  final AddAuthorUseCase addAuthorUseCase;
  final UpdateAuthorUseCase updateAuthorUseCase;
  final DeleteAuthorUseCase deleteAuthorUseCase;

  AuthorBloc({
    required this.getAuthorsUseCase,
    required this.addAuthorUseCase,
    required this.updateAuthorUseCase,
    required this.deleteAuthorUseCase,
  }) : super(const AuthorState()) {
    on<AuthorsRequested>(_onAuthorsRequested);
    on<AuthorAddRequested>(_onAuthorAddRequested);
    on<AuthorUpdateRequested>(_onAuthorUpdateRequested);
    on<AuthorDeleteRequested>(_onAuthorDeleteRequested);
  }

  Future<void> _onAuthorsRequested(AuthorsRequested event, Emitter<AuthorState> emit) async {
    emit(state.copyWith(status: AuthorStatus.loading));
    try {
      final authors = await getAuthorsUseCase(query: event.query);
      emit(state.copyWith(status: AuthorStatus.loaded, authors: authors));
    } catch (e) {
      emit(state.copyWith(status: AuthorStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onAuthorAddRequested(AuthorAddRequested event, Emitter<AuthorState> emit) async {
    await addAuthorUseCase(event.author);
    add(const AuthorsRequested());
  }

  Future<void> _onAuthorUpdateRequested(AuthorUpdateRequested event, Emitter<AuthorState> emit) async {
    await updateAuthorUseCase(event.author);
    add(const AuthorsRequested());
  }

  Future<void> _onAuthorDeleteRequested(AuthorDeleteRequested event, Emitter<AuthorState> emit) async {
    await deleteAuthorUseCase(event.authorId);
    add(const AuthorsRequested());
  }
}
