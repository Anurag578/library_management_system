import '../entities/book.dart';

abstract class BookRepository {
  Future<List<Book>> getBooks({String query = ''});
  Future<Book> getBookById(int id);
  Future<void> addBook(Book book);
  Future<void> updateBook(Book book);
  Future<void> deleteBook(int id);
  Future<void> decrementAvailability(int bookId, int quantity);
  Future<void> incrementAvailability(int bookId, int quantity);
}
