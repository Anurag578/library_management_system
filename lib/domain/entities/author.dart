class Author {
  final int id;
  final String name;
  final String bio;

  const Author({
    required this.id,
    required this.name,
    required this.bio,
  });

  Author copyWith({String? name, String? bio}) {
    return Author(
      id: id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
    );
  }
}
