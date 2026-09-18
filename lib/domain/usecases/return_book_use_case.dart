import '../repositories/borrow_repository.dart';

class ReturnBookUseCase {
  final BorrowRepository repository;
  ReturnBookUseCase(this.repository);

  Future<void> call(int recordId) => repository.returnBook(recordId);
}
