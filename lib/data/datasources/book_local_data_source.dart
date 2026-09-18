import '../../domain/entities/book.dart';

class BookLocalDataSource {
  final List<Book> _books = [
    const Book(id: 1, title: 'Clean Code', author: 'Robert C. Martin', genre: 'Software Engineering', totalCopies: 4, availableCopies: 2),
    const Book(id: 2, title: 'The Pragmatic Programmer', author: 'David Thomas', genre: 'Software Engineering', totalCopies: 3, availableCopies: 3),
    const Book(id: 3, title: 'Atomic Habits', author: 'James Clear', genre: 'Self Help', totalCopies: 5, availableCopies: 1),
    const Book(id: 4, title: 'Sapiens', author: 'Yuval Noah Harari', genre: 'History', totalCopies: 2, availableCopies: 0),
    const Book(id: 5, title: 'The Pragmatic Thinker', author: 'Andy Hunt', genre: 'Software Engineering', totalCopies: 3, availableCopies: 3),
    const Book(id: 6, title: 'Deep Work', author: 'Cal Newport', genre: 'Productivity', totalCopies: 4, availableCopies: 4),
  ];
  int _nextId = 7;

  Future<List<Book>> getBooks({String query = ''}) async {
    if (query.isEmpty) return List.unmodifiable(_books);
    final lower = query.toLowerCase();
    return _books
        .where((b) => b.title.toLowerCase().contains(lower) || b.author.toLowerCase().contains(lower))
        .toList();
  }

  Future<Book> getBookById(int id) async {
    return _books.firstWhere((b) => b.id == id, orElse: () => throw Exception('Book not found'));
  }

  Future<void> addBook(Book book) async {
    _books.add(Book(
      id: _nextId++,
      title: book.title,
      author: book.author,
      genre: book.genre,
      totalCopies: book.totalCopies,
      availableCopies: book.totalCopies, // a newly added book starts fully available
    ));
  }

  Future<void> updateBook(Book book) async {
    final index = _books.indexWhere((b) => b.id == book.id);
    if (index != -1) _books[index] = book;
  }

  Future<void> deleteBook(int id) async {
    _books.removeWhere((b) => b.id == id);
  }

  Future<void> decrementAvailability(int bookId, int quantity) async {
    final index = _books.indexWhere((b) => b.id == bookId);
    if (index != -1) {
      final newAvailable = (_books[index].availableCopies - quantity).clamp(0, _books[index].totalCopies);
      _books[index] = _books[index].copyWith(availableCopies: newAvailable);
    }
  }

  Future<void> incrementAvailability(int bookId, int quantity) async {
    final index = _books.indexWhere((b) => b.id == bookId);
    if (index != -1) {
      final newAvailable = (_books[index].availableCopies + quantity).clamp(0, _books[index].totalCopies);
      _books[index] = _books[index].copyWith(availableCopies: newAvailable);
    }
  }
}
