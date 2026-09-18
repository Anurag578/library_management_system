import '../entities/book.dart';
import '../repositories/book_repository.dart';

class UpdateBookUseCase {
  final BookRepository repository;
  UpdateBookUseCase(this.repository);

  Future<void> call(Book book) => repository.updateBook(book);
}
