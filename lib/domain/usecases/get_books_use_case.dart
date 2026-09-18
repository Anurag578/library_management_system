import '../entities/book.dart';
import '../repositories/book_repository.dart';

class GetBooksUseCase {
  final BookRepository repository;
  GetBooksUseCase(this.repository);

  Future<List<Book>> call({String query = ''}) => repository.getBooks(query: query);
}
