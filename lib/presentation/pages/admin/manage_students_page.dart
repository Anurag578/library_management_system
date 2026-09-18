import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/student.dart';
import '../../bloc/student/student_bloc.dart';
import '../../bloc/student/student_event.dart';
import '../../bloc/student/student_state.dart';

/// "Students" screen: an Add Students form plus a Student Lists table with
/// Edit / Delete actions - mirrors the Kutumba Library System design.
class ManageStudentsPage extends StatefulWidget {
  const ManageStudentsPage({super.key});

  @override
  State<ManageStudentsPage> createState() => _ManageStudentsPageState();
}

class _ManageStudentsPageState extends State<ManageStudentsPage> {
  final _formKey = GlobalKey<FormState>();
  final _studentIdController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _facultyController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  int? _editingId;

  @override
  void initState() {
    super.initState();
    context.read<StudentBloc>().add(const StudentsRequested());
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _fullNameController.dispose();
    _facultyController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _startEdit(Student student) {
    setState(() {
      _editingId = student.id;
      _studentIdController.text = student.studentId;
      _fullNameController.text = student.fullName;
      _facultyController.text = student.faculty;
      _emailController.text = student.email;
      _contactController.text = student.contactNo;
    });
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _studentIdController.clear();
    _fullNameController.clear();
    _facultyController.clear();
    _emailController.clear();
    _contactController.clear();
    setState(() => _editingId = null);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final student = Student(
      id: _editingId ?? 0,
      studentId: _studentIdController.text.trim(),
      fullName: _fullNameController.text.trim(),
      faculty: _facultyController.text.trim(),
      email: _emailController.text.trim(),
      contactNo: _contactController.text.trim(),
    );
    if (_editingId == null) {
      context.read<StudentBloc>().add(StudentAddRequested(student));
    } else {
      context.read<StudentBloc>().add(StudentUpdateRequested(student));
    }
    _resetForm();
  }

  void _confirmDelete(Student student) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete student?'),
        content: Text('Remove "${student.fullName}" from the student list?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<StudentBloc>().add(StudentDeleteRequested(student.id));
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
      appBar: AppBar(title: const Text('Students')),
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
                          const Icon(Icons.person_add_alt_outlined),
                          const SizedBox(width: 8),
                          Text(_editingId == null ? 'Add Students' : 'Edit Student',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _studentIdController,
                              decoration:
                                  const InputDecoration(labelText: 'Student ID', border: OutlineInputBorder()),
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _facultyController,
                              decoration: const InputDecoration(labelText: 'Faculty', border: OutlineInputBorder()),
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _fullNameController,
                        decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Full name is required' : null,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                              validator: (v) =>
                                  (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _contactController,
                              keyboardType: TextInputType.phone,
                              decoration:
                                  const InputDecoration(labelText: 'Contact No.', border: OutlineInputBorder()),
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                            ),
                          ),
                        ],
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
                            label: Text(_editingId == null ? 'Add Student' : 'Save Changes'),
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
                Text('Student Lists', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            BlocBuilder<StudentBloc, StudentState>(
              builder: (context, state) {
                if (state.status == StudentStatus.loading || state.status == StudentStatus.initial) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state.students.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text('No students added yet.')),
                  );
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Student ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Faculty')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Contact No.')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: state.students
                        .map(
                          (student) => DataRow(cells: [
                            DataCell(Text(student.studentId)),
                            DataCell(Text(student.fullName)),
                            DataCell(Text(student.faculty)),
                            DataCell(Text(student.email)),
                            DataCell(Text(student.contactNo)),
                            DataCell(Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 18),
                                  color: Colors.amber.shade700,
                                  onPressed: () => _startEdit(student),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 18),
                                  color: Colors.red.shade600,
                                  onPressed: () => _confirmDelete(student),
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
