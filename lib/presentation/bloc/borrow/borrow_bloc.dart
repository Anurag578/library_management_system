// Provided once at the app root (see main.dart), so the transaction log
// stays consistent across the whole admin app.

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_all_borrow_records_use_case.dart';
import '../../../domain/usecases/issue_book_use_case.dart';
import '../../../domain/usecases/return_book_use_case.dart';
import 'borrow_event.dart';
import 'borrow_state.dart';

class BorrowBloc extends Bloc<BorrowEvent, BorrowState> {
  final GetAllBorrowRecordsUseCase getAllBorrowRecordsUseCase;
  final IssueBookUseCase issueBookUseCase;
  final ReturnBookUseCase returnBookUseCase;

  BorrowBloc({
    required this.getAllBorrowRecordsUseCase,
    required this.issueBookUseCase,
    required this.returnBookUseCase,
  }) : super(const BorrowState()) {
    on<AllBorrowsRequested>(_onAllBorrowsRequested);
    on<IssueBookRequested>(_onIssueBookRequested);
    on<ReturnRequested>(_onReturnRequested);
  }

  Future<void> _onAllBorrowsRequested(AllBorrowsRequested event, Emitter<BorrowState> emit) async {
    emit(state.copyWith(status: BorrowStatus.loading));
    try {
      final records = await getAllBorrowRecordsUseCase();
      emit(state.copyWith(status: BorrowStatus.loaded, records: records));
    } catch (e) {
      emit(state.copyWith(status: BorrowStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onIssueBookRequested(IssueBookRequested event, Emitter<BorrowState> emit) async {
    try {
      await issueBookUseCase(
        studentId: event.studentId,
        studentCode: event.studentCode,
        studentName: event.studentName,
        bookId: event.bookId,
        bookTitle: event.bookTitle,
        quantity: event.quantity,
        borrowDate: event.borrowDate,
      );
      add(AllBorrowsRequested());
    } catch (e) {
      emit(state.copyWith(status: BorrowStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onReturnRequested(ReturnRequested event, Emitter<BorrowState> emit) async {
    await returnBookUseCase(event.recordId);
    add(AllBorrowsRequested());
  }
}
