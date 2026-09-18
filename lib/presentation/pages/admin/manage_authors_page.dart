import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/author.dart';
import '../../bloc/author/author_bloc.dart';
import '../../bloc/author/author_event.dart';
import '../../bloc/author/author_state.dart';

/// "Author" screen: an Author Info form to add a new author, plus an
/// Author Details table listing existing authors with Edit / Delete actions -
/// mirrors the Kutumba Library System design.
class ManageAuthorsPage extends StatefulWidget {
  const ManageAuthorsPage({super.key});

  @override
  State<ManageAuthorsPage> createState() => _ManageAuthorsPageState();
}

class _ManageAuthorsPageState extends State<ManageAuthorsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  int? _editingId;

  @override
  void initState() {
    super.initState();
    context.read<AuthorBloc>().add(const AuthorsRequested());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _startEdit(Author author) {
    setState(() {
      _editingId = author.id;
      _nameController.text = author.name;
      _bioController.text = author.bio;
    });
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _bioController.clear();
    setState(() => _editingId = null);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_editingId == null) {
      context.read<AuthorBloc>().add(
            AuthorAddRequested(Author(id: 0, name: _nameController.text.trim(), bio: _bioController.text.trim())),
          );
    } else {
      context.read<AuthorBloc>().add(
            AuthorUpdateRequested(
              Author(id: _editingId!, name: _nameController.text.trim(), bio: _bioController.text.trim()),
            ),
          );
    }
    _resetForm();
  }

  void _confirmDelete(Author author) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete author?'),
        content: Text('Remove "${author.name}" from the author list?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<AuthorBloc>().add(AuthorDeleteRequested(author.id));
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Author')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person_outline),
                          const SizedBox(width: 8),
                          Text(_editingId == null ? 'Author Info' : 'Edit Author',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Author Name', border: OutlineInputBorder()),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Author name is required' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _bioController,
                        maxLines: 3,
                        decoration: const InputDecoration(labelText: 'Bio', border: OutlineInputBorder()),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Bio is required' : null,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (_editingId != null)
                            TextButton(onPressed: _resetForm, child: const Text('Cancel')),
                          const SizedBox(width: 8),
                          FilledButton.icon(
                            onPressed: _submit,
                            icon: Icon(_editingId == null ? Icons.add : Icons.check),
                            label: Text(_editingId == null ? 'Add Author' : 'Save Changes'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Icon(Icons.list_alt_outlined),
                SizedBox(width: 8),
                Text('Author Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            BlocBuilder<AuthorBloc, AuthorState>(
              builder: (context, state) {
                if (state.status == AuthorStatus.loading || state.status == AuthorStatus.initial) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state.authors.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text('No authors added yet.')),
                  );
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Author ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Bio')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: state.authors
                        .map(
                          (author) => DataRow(cells: [
                            DataCell(Text(author.id.toString())),
                            DataCell(Text(author.name)),
                            DataCell(SizedBox(
                              width: 220,
                              child: Text(author.bio, overflow: TextOverflow.ellipsis, maxLines: 2),
                            )),
                            DataCell(Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () => _startEdit(author),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.amber.shade600,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Edit'),
                                ),
                                const SizedBox(width: 6),
                                TextButton(
                                  onPressed: () => _confirmDelete(author),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.red.shade600,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                            )),
                          ]),
                        )
                        .toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
