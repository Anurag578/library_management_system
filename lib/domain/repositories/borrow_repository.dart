import '../entities/borrow_record.dart';

abstract class BorrowRepository {
  Future<List<BorrowRecord>> getAllRecords();

  /// Admin issues one or more copies of a book to a student. This creates
  /// the transaction record AND reduces the book's available copies by
  /// [quantity] - both through the injected BookRepository, keeping the
  /// two pieces of data consistent.
  Future<void> issueBook({
    required int studentId,
    required String studentCode,
    required String studentName,
    required int bookId,
    required String bookTitle,
    required int quantity,
    required DateTime borrowDate,
  });

  /// Marks a transaction as returned and restores the book's availability
  /// by that record's quantity.
  Future<void> returnBook(int recordId);
}
