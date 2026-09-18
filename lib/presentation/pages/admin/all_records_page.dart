import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/borrow/borrow_bloc.dart';
import '../../bloc/borrow/borrow_event.dart';
import '../../bloc/borrow/borrow_state.dart';
import 'issue_book_page.dart';

/// "Transaction" screen: every issue/return transaction, with an action to
/// mark a still-outstanding transaction as returned, and a FAB to issue a
/// new book to a student.
class AllRecordsPage extends StatefulWidget {
  const AllRecordsPage({super.key});

  @override
  State<AllRecordsPage> createState() => _AllRecordsPageState();
}

class _AllRecordsPageState extends State<AllRecordsPage> {
  @override
  void initState() {
    super.initState();
    context.read<BorrowBloc>().add(AllBorrowsRequested());
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd-MM-yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction')),
      body: BlocBuilder<BorrowBloc, BorrowState>(
        builder: (context, state) {
          if (state.status == BorrowStatus.loading || state.status == BorrowStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.records.isEmpty) {
            return const Center(child: Text('No transactions yet. Tap + to issue a book.'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('T.ID')),
                  DataColumn(label: Text('Student ID')),
                  DataColumn(label: Text('Student Name')),
                  DataColumn(label: Text('Book')),
                  DataColumn(label: Text('Qty')),
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Action')),
                ],
                rows: state.records.map((record) {
                  final type = record.transactionType;
                  final typeColor = type == 'Return' ? Colors.grey : (record.isOverdue ? Colors.red : Colors.blue);
                  final date = record.isReturned ? record.returnedDate! : record.borrowDate;
                  return DataRow(cells: [
                    DataCell(Text('T-${record.id.toString().padLeft(4, '0')}')),
                    DataCell(Text(record.studentCode)),
                    DataCell(SizedBox(width: 130, child: Text(record.studentName, overflow: TextOverflow.ellipsis))),
                    DataCell(SizedBox(width: 140, child: Text(record.bookTitle, overflow: TextOverflow.ellipsis))),
                    DataCell(Text('${record.quantity}')),
                    DataCell(Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(type, style: TextStyle(color: typeColor, fontWeight: FontWeight.w600, fontSize: 12)),
                    )),
                    DataCell(Text(dateFormat.format(date))),
                    DataCell(
                      record.isReturned
                          ? const Text('-', style: TextStyle(color: Colors.grey))
                          : TextButton(
                              onPressed: () => context.read<BorrowBloc>().add(ReturnRequested(record.id)),
                              child: const Text('Mark Returned'),
                            ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IssueBookPage())),
        icon: const Icon(Icons.add),
        label: const Text('Issue Book'),
      ),
    );
  }
}
