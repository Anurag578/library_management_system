import '../../domain/entities/borrow_record.dart';

class BorrowLocalDataSource {
  final List<BorrowRecord> _records = [];
  int _nextId = 1;

  Future<List<BorrowRecord>> getAllRecords() async {
    return _records.reversed.toList();
  }

  Future<BorrowRecord> createRecord({
    required int studentId,
    required String studentCode,
    required String studentName,
    required int bookId,
    required String bookTitle,
    required int quantity,
    required DateTime borrowDate,
  }) async {
    final record = BorrowRecord(
      id: _nextId++,
      bookId: bookId,
      bookTitle: bookTitle,
      studentId: studentId,
      studentCode: studentCode,
      studentName: studentName,
      quantity: quantity,
      borrowDate: borrowDate,
      dueDate: borrowDate.add(const Duration(days: 14)),
    );
    _records.add(record);
    return record;
  }

  Future<BorrowRecord> markReturned(int recordId) async {
    final index = _records.indexWhere((r) => r.id == recordId);
    if (index == -1) throw Exception('Transaction record not found');
    final updated = _records[index].copyWith(returnedDate: DateTime.now());
    _records[index] = updated;
    return updated;
  }
}
