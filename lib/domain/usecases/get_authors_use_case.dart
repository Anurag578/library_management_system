import '../entities/author.dart';
import '../repositories/author_repository.dart';

class GetAuthorsUseCase {
  final AuthorRepository repository;
  GetAuthorsUseCase(this.repository);

  Future<List<Author>> call({String query = ''}) => repository.getAuthors(query: query);
}
