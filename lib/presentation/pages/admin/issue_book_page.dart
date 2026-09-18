import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/book.dart';
import '../../../domain/entities/student.dart';
import '../../bloc/book/book_bloc.dart';
import '../../bloc/book/book_event.dart';
import '../../bloc/book/book_state.dart';
import '../../bloc/borrow/borrow_bloc.dart';
import '../../bloc/borrow/borrow_event.dart';
import '../../bloc/student/student_bloc.dart';
import '../../bloc/student/student_event.dart';
import '../../bloc/student/student_state.dart';

/// Lets the admin record that a specific student has taken a specific
/// book (and how many copies), on a chosen date.
class IssueBookPage extends StatefulWidget {
  const IssueBookPage({super.key});

  @override
  State<IssueBookPage> createState() => _IssueBookPageState();
}

class _IssueBookPageState extends State<IssueBookPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController(text: '1');

  Student? _selectedStudent;
  Book? _selectedBook;
  DateTime _borrowDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<StudentBloc>().add(const StudentsRequested());
    context.read<BookBloc>().add(const BooksRequested());
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _borrowDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) setState(() => _borrowDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStudent == null || _selectedBook == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both a student and a book')),
      );
      return;
    }
    final quantity = int.parse(_quantityController.text);
    if (quantity > _selectedBook!.availableCopies) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Only ${_selectedBook!.availableCopies} cop${_selectedBook!.availableCopies == 1 ? 'y' : 'ies'} available')),
      );
      return;
    }

    context.read<BorrowBloc>().add(IssueBookRequested(
          studentId: _selectedStudent!.id,
          studentCode: _selectedStudent!.studentId,
          studentName: _selectedStudent!.fullName,
          bookId: _selectedBook!.id,
          bookTitle: _selectedBook!.title,
          quantity: quantity,
          borrowDate: _borrowDate,
        ));
    // Books list needs refreshing elsewhere too, since availability changed.
    context.read<BookBloc>().add(const BooksRequested());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Issue Book')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlocBuilder<StudentBloc, StudentState>(
                builder: (context, state) {
                  return DropdownButtonFormField<Student>(
                    value: _selectedStudent,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Student', border: OutlineInputBorder()),
                    items: state.students
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text('${s.fullName} (${s.studentId})', overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedStudent = value),
                    hint: state.students.isEmpty
                        ? const Text('No students yet - add one first')
                        : const Text('Select a student'),
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<BookBloc, BookState>(
                builder: (context, state) {
                  final availableBooks = state.books.where((b) => b.isAvailable).toList();
                  return DropdownButtonFormField<Book>(
                    value: _selectedBook,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Book', border: OutlineInputBorder()),
                    items: availableBooks
                        .map((b) => DropdownMenuItem(
                              value: b,
                              child: Text('${b.title} (${b.availableCopies} available)', overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedBook = value),
                    hint: availableBooks.isEmpty
                        ? const Text('No books currently available')
                        : const Text('Select a book'),
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()),
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n < 1) return 'Enter a number 1 or greater';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Date Issued', border: OutlineInputBorder()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(dateFormat.format(_borrowDate)),
                      const Icon(Icons.calendar_today, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 50,
                child: FilledButton.icon(
                  icon: const Icon(Icons.assignment_turned_in_outlined),
                  label: const Text('Issue Book'),
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
