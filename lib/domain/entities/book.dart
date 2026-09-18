class Book {
  final int id;
  final String title;
  final String author;
  final String genre;
  final int totalCopies;
  final int availableCopies;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.totalCopies,
    required this.availableCopies,
  });

  bool get isAvailable => availableCopies > 0;

  Book copyWith({
    String? title,
    String? author,
    String? genre,
    int? totalCopies,
    int? availableCopies,
  }) {
    return Book(
      id: id,
      title: title ?? this.title,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      totalCopies: totalCopies ?? this.totalCopies,
      availableCopies: availableCopies ?? this.availableCopies,
    );
  }
}
