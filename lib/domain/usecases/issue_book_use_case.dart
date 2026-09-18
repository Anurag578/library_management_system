import '../repositories/borrow_repository.dart';

class IssueBookUseCase {
  final BorrowRepository repository;
  IssueBookUseCase(this.repository);

  Future<void> call({
    required int studentId,
    required String studentCode,
    required String studentName,
    required int bookId,
    required String bookTitle,
    required int quantity,
    required DateTime borrowDate,
  }) =>
      repository.issueBook(
        studentId: studentId,
        studentCode: studentCode,
        studentName: studentName,
        bookId: bookId,
        bookTitle: bookTitle,
        quantity: quantity,
        borrowDate: borrowDate,
      );
}
