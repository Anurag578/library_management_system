import '../../domain/entities/author.dart';

class AuthorLocalDataSource {
  final List<Author> _authors = [
    const Author(id: 1, name: 'Robert C. Martin', bio: 'Author of Clean Code and Clean Architecture.'),
    const Author(id: 2, name: 'James Clear', bio: 'Author of Atomic Habits.'),
    const Author(id: 3, name: 'Yuval Noah Harari', bio: 'Historian and author of Sapiens.'),
  ];
  int _nextId = 4;

  Future<List<Author>> getAuthors({String query = ''}) async {
    if (query.isEmpty) return List.unmodifiable(_authors);
    final lower = query.toLowerCase();
    return _authors.where((a) => a.name.toLowerCase().contains(lower)).toList();
  }

  Future<void> addAuthor(Author author) async {
    _authors.add(Author(id: _nextId++, name: author.name, bio: author.bio));
  }

  Future<void> updateAuthor(Author author) async {
    final index = _authors.indexWhere((a) => a.id == author.id);
    if (index != -1) _authors[index] = author;
  }

  Future<void> deleteAuthor(int id) async {
    _authors.removeWhere((a) => a.id == id);
  }
}
