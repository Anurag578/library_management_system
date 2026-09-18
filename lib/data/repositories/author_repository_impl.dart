import '../../domain/entities/author.dart';
import '../../domain/repositories/author_repository.dart';
import '../datasources/author_local_data_source.dart';

class AuthorRepositoryImpl implements AuthorRepository {
  final AuthorLocalDataSource dataSource;
  AuthorRepositoryImpl(this.dataSource);

  @override
  Future<List<Author>> getAuthors({String query = ''}) => dataSource.getAuthors(query: query);

  @override
  Future<void> addAuthor(Author author) => dataSource.addAuthor(author);

  @override
  Future<void> updateAuthor(Author author) => dataSource.updateAuthor(author);

  @override
  Future<void> deleteAuthor(int id) => dataSource.deleteAuthor(id);
}
