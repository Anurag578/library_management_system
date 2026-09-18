import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/book_local_data_source.dart';

class BookRepositoryImpl implements BookRepository {
  final BookLocalDataSource dataSource;
  BookRepositoryImpl(this.dataSource);

  @override
  Future<List<Book>> getBooks({String query = ''}) => dataSource.getBooks(query: query);

  @override
  Future<Book> getBookById(int id) => dataSource.getBookById(id);

  @override
  Future<void> addBook(Book book) => dataSource.addBook(book);

  @override
  Future<void> updateBook(Book book) => dataSource.updateBook(book);

  @override
  Future<void> deleteBook(int id) => dataSource.deleteBook(id);

  @override
  Future<void> decrementAvailability(int bookId, int quantity) => dataSource.decrementAvailability(bookId, quantity);

  @override
  Future<void> incrementAvailability(int bookId, int quantity) => dataSource.incrementAvailability(bookId, quantity);
}
