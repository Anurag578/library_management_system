import '../repositories/author_repository.dart';

class DeleteAuthorUseCase {
  final AuthorRepository repository;
  DeleteAuthorUseCase(this.repository);

  Future<void> call(int id) => repository.deleteAuthor(id);
}
