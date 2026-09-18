import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_book_use_case.dart';
import '../../../domain/usecases/delete_book_use_case.dart';
import '../../../domain/usecases/get_books_use_case.dart';
import '../../../domain/usecases/update_book_use_case.dart';
import 'book_event.dart';
import 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final GetBooksUseCase getBooksUseCase;
  final AddBookUseCase addBookUseCase;
  final UpdateBookUseCase updateBookUseCase;
  final DeleteBookUseCase deleteBookUseCase;

  BookBloc({
    required this.getBooksUseCase,
    required this.addBookUseCase,
    required this.updateBookUseCase,
    required this.deleteBookUseCase,
  }) : super(const BookState()) {
    on<BooksRequested>(_onBooksRequested);
    on<BookAddRequested>(_onBookAddRequested);
    on<BookUpdateRequested>(_onBookUpdateRequested);
    on<BookDeleteRequested>(_onBookDeleteRequested);
  }

  Future<void> _onBooksRequested(BooksRequested event, Emitter<BookState> emit) async {
    emit(state.copyWith(status: BookStatus.loading));
    try {
      final books = await getBooksUseCase(query: event.query);
      emit(state.copyWith(status: BookStatus.loaded, books: books));
    } catch (e) {
      emit(state.copyWith(status: BookStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onBookAddRequested(BookAddRequested event, Emitter<BookState> emit) async {
    await addBookUseCase(event.book);
    add(const BooksRequested());
  }

  Future<void> _onBookUpdateRequested(BookUpdateRequested event, Emitter<BookState> emit) async {
    await updateBookUseCase(event.book);
    add(const BooksRequested());
  }

  Future<void> _onBookDeleteRequested(BookDeleteRequested event, Emitter<BookState> emit) async {
    await deleteBookUseCase(event.bookId);
    add(const BooksRequested());
  }
}
