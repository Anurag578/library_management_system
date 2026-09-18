// This repository depends on BookRepository (the abstract contract, not
// the concrete class) to keep book availability counts correct whenever a
// book is issued or returned.

import '../../domain/entities/borrow_record.dart';
import '../../domain/repositories/book_repository.dart';
import '../../domain/repositories/borrow_repository.dart';
import '../datasources/borrow_local_data_source.dart';

class BorrowRepositoryImpl implements BorrowRepository {
  final BorrowLocalDataSource dataSource;
  final BookRepository bookRepository;

  BorrowRepositoryImpl(this.dataSource, this.bookRepository);

  @override
  Future<List<BorrowRecord>> getAllRecords() => dataSource.getAllRecords();

  @override
  Future<void> issueBook({
    required int studentId,
    required String studentCode,
    required String studentName,
    required int bookId,
    required String bookTitle,
    required int quantity,
    required DateTime borrowDate,
  }) async {
    await dataSource.createRecord(
      studentId: studentId,
      studentCode: studentCode,
      studentName: studentName,
      bookId: bookId,
      bookTitle: bookTitle,
      quantity: quantity,
      borrowDate: borrowDate,
    );
    await bookRepository.decrementAvailability(bookId, quantity);
  }

  @override
  Future<void> returnBook(int recordId) async {
    final allRecords = await dataSource.getAllRecords();
    final record = allRecords.firstWhere((r) => r.id == recordId, orElse: () => throw Exception('Record not found'));
    await dataSource.markReturned(recordId);
    await bookRepository.incrementAvailability(record.bookId, record.quantity);
  }
}
