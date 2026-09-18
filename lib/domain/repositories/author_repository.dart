import '../entities/author.dart';

abstract class AuthorRepository {
  Future<List<Author>> getAuthors({String query = ''});
  Future<void> addAuthor(Author author);
  Future<void> updateAuthor(Author author);
  Future<void> deleteAuthor(int id);
}
