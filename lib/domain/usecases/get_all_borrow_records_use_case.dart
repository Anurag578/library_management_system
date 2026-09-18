import '../entities/borrow_record.dart';
import '../repositories/borrow_repository.dart';

class GetAllBorrowRecordsUseCase {
  final BorrowRepository repository;
  GetAllBorrowRecordsUseCase(this.repository);

  Future<List<BorrowRecord>> call() => repository.getAllRecords();
}
