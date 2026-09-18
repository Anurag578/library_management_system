class BorrowRecord {
  final int id;
  final int bookId;
  final String bookTitle;   // denormalized for easy display
  final int studentId;      // references Student.id
  final String studentCode; // denormalized Student.studentId (e.g. "STU001")
  final String studentName; // denormalized Student.fullName
  final int quantity;       // how many copies were taken in this transaction
  final DateTime borrowDate;
  final DateTime dueDate;
  final DateTime? returnedDate;

  const BorrowRecord({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.studentId,
    required this.studentCode,
    required this.studentName,
    required this.quantity,
    required this.borrowDate,
    required this.dueDate,
    this.returnedDate,
  });

  bool get isReturned => returnedDate != null;
  bool get isOverdue => !isReturned && DateTime.now().isAfter(dueDate);

  /// Matches the "Transaction Type" column in the Transaction screen -
  /// a record is a "Borrow" until it's marked returned, then a "Return".
  String get transactionType => isReturned ? 'Return' : 'Borrow';

  BorrowRecord copyWith({DateTime? returnedDate}) {
    return BorrowRecord(
      id: id,
      bookId: bookId,
      bookTitle: bookTitle,
      studentId: studentId,
      studentCode: studentCode,
      studentName: studentName,
      quantity: quantity,
      borrowDate: borrowDate,
      dueDate: dueDate,
      returnedDate: returnedDate ?? this.returnedDate,
    );
  }
}
