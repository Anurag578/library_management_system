import '../repositories/book_repository.dart';

class DeleteBookUseCase {
  final BookRepository repository;
  DeleteBookUseCase(this.repository);

  Future<void> call(int bookId) => repository.deleteBook(bookId);
}
