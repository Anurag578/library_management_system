import '../entities/author.dart';
import '../repositories/author_repository.dart';

class AddAuthorUseCase {
  final AuthorRepository repository;
  AddAuthorUseCase(this.repository);

  Future<void> call(Author author) => repository.addAuthor(author);
}
