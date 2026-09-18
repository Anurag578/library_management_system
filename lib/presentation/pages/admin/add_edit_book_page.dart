import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/book.dart';
import '../../bloc/book/book_bloc.dart';
import '../../bloc/book/book_event.dart';

class AddEditBookPage extends StatefulWidget {
  final Book? existingBook; // null means "add new book"
  const AddEditBookPage({super.key, this.existingBook});

  @override
  State<AddEditBookPage> createState() => _AddEditBookPageState();
}

class _AddEditBookPageState extends State<AddEditBookPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final TextEditingController _genreController;
  late final TextEditingController _copiesController;

  bool get _isEditing => widget.existingBook != null;

  @override
  void initState() {
    super.initState();
    final book = widget.existingBook;
    _titleController = TextEditingController(text: book?.title ?? '');
    _authorController = TextEditingController(text: book?.author ?? '');
    _genreController = TextEditingController(text: book?.genre ?? '');
    _copiesController = TextEditingController(text: book?.totalCopies.toString() ?? '1');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _genreController.dispose();
    _copiesController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final totalCopies = int.parse(_copiesController.text);

    if (_isEditing) {
      final original = widget.existingBook!;
      // Keep availableCopies proportionate if total copies changed.
      final diff = totalCopies - original.totalCopies;
      final newAvailable = (original.availableCopies + diff).clamp(0, totalCopies);
      context.read<BookBloc>().add(BookUpdateRequested(Book(
            id: original.id,
            title: _titleController.text.trim(),
            author: _authorController.text.trim(),
            genre: _genreController.text.trim(),
            totalCopies: totalCopies,
            availableCopies: newAvailable,
          )));
    } else {
      context.read<BookBloc>().add(BookAddRequested(Book(
            id: 0, // ignored by the data source, which assigns a real id
            title: _titleController.text.trim(),
            author: _authorController.text.trim(),
            genre: _genreController.text.trim(),
            totalCopies: totalCopies,
            availableCopies: totalCopies,
          )));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Book' : 'Add Book')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Author is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _genreController,
                decoration: const InputDecoration(labelText: 'Genre'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Genre is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _copiesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Total Copies'),
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n < 1) return 'Enter a number 1 or greater';
                  return null;
                },
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 50,
                child: FilledButton(
                  onPressed: _save,
                  child: Text(_isEditing ? 'Save Changes' : 'Add Book'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
