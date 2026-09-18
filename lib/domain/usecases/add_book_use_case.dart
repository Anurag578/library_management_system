import '../entities/book.dart';
import '../repositories/book_repository.dart';

class AddBookUseCase {
  final BookRepository repository;
  AddBookUseCase(this.repository);

  Future<void> call(Book book) => repository.addBook(book);
}
