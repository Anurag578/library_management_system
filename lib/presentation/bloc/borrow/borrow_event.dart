import 'package:equatable/equatable.dart';

abstract class BorrowEvent extends Equatable {
  const BorrowEvent();
  @override
  List<Object?> get props => [];
}

class AllBorrowsRequested extends BorrowEvent {}

/// Admin issues a book to a student - creates a transaction record and
/// reduces the book's available copies by [quantity].
class IssueBookRequested extends BorrowEvent {
  final int studentId;
  final String studentCode;
  final String studentName;
  final int bookId;
  final String bookTitle;
  final int quantity;
  final DateTime borrowDate;

  const IssueBookRequested({
    required this.studentId,
    required this.studentCode,
    required this.studentName,
    required this.bookId,
    required this.bookTitle,
    required this.quantity,
    required this.borrowDate,
  });

  @override
  List<Object?> get props => [studentId, bookId, quantity, borrowDate];
}

class ReturnRequested extends BorrowEvent {
  final int recordId;
  const ReturnRequested(this.recordId);
  @override
  List<Object?> get props => [recordId];
}
