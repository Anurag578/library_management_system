import 'package:equatable/equatable.dart';
import '../../../domain/entities/book.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();
  @override
  List<Object?> get props => [];
}

class BooksRequested extends BookEvent {
  final String query;
  const BooksRequested({this.query = ''});
  @override
  List<Object?> get props => [query];
}

class BookAddRequested extends BookEvent {
  final Book book;
  const BookAddRequested(this.book);
  @override
  List<Object?> get props => [book.id];
}

class BookUpdateRequested extends BookEvent {
  final Book book;
  const BookUpdateRequested(this.book);
  @override
  List<Object?> get props => [book.id];
}

class BookDeleteRequested extends BookEvent {
  final int bookId;
  const BookDeleteRequested(this.bookId);
  @override
  List<Object?> get props => [bookId];
}
