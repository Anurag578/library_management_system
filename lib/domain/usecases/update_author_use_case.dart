import '../entities/author.dart';
import '../repositories/author_repository.dart';

class UpdateAuthorUseCase {
  final AuthorRepository repository;
  UpdateAuthorUseCase(this.repository);

  Future<void> call(Author author) => repository.updateAuthor(author);
}
