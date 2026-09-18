import 'package:equatable/equatable.dart';
import '../../../domain/entities/book.dart';

enum BookStatus { initial, loading, loaded, error }

class BookState extends Equatable {
  final BookStatus status;
  final List<Book> books;
  final String? errorMessage;

  const BookState({this.status = BookStatus.initial, this.books = const [], this.errorMessage});

  BookState copyWith({BookStatus? status, List<Book>? books, String? errorMessage}) {
    return BookState(
      status: status ?? this.status,
      books: books ?? this.books,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, books, errorMessage];
}
