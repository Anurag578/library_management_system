import 'package:equatable/equatable.dart';
import '../../../domain/entities/borrow_record.dart';

enum BorrowStatus { initial, loading, loaded, error }

class BorrowState extends Equatable {
  final BorrowStatus status;
  final List<BorrowRecord> records;
  final String? errorMessage;

  const BorrowState({this.status = BorrowStatus.initial, this.records = const [], this.errorMessage});

  BorrowState copyWith({BorrowStatus? status, List<BorrowRecord>? records, String? errorMessage}) {
    return BorrowState(
      status: status ?? this.status,
      records: records ?? this.records,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, records, errorMessage];
}
