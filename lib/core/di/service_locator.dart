// DEPENDENCY INJECTION - single place where every object in the app gets
// built and registered.

import 'package:get_it/get_it.dart';

import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/author_local_data_source.dart';
import '../../data/datasources/book_local_data_source.dart';
import '../../data/datasources/borrow_local_data_source.dart';
import '../../data/datasources/student_local_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/author_repository_impl.dart';
import '../../data/repositories/book_repository_impl.dart';
import '../../data/repositories/borrow_repository_impl.dart';
import '../../data/repositories/student_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/author_repository.dart';
import '../../domain/repositories/book_repository.dart';
import '../../domain/repositories/borrow_repository.dart';
import '../../domain/repositories/student_repository.dart';
import '../../domain/usecases/add_author_use_case.dart';
import '../../domain/usecases/add_book_use_case.dart';
import '../../domain/usecases/add_student_use_case.dart';
import '../../domain/usecases/delete_author_use_case.dart';
import '../../domain/usecases/delete_book_use_case.dart';
import '../../domain/usecases/delete_student_use_case.dart';
import '../../domain/usecases/get_all_borrow_records_use_case.dart';
import '../../domain/usecases/get_authors_use_case.dart';
import '../../domain/usecases/get_books_use_case.dart';
import '../../domain/usecases/get_students_use_case.dart';
import '../../domain/usecases/issue_book_use_case.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/return_book_use_case.dart';
import '../../domain/usecases/update_author_use_case.dart';
import '../../domain/usecases/update_book_use_case.dart';
import '../../domain/usecases/update_student_use_case.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/author/author_bloc.dart';
import '../../presentation/bloc/book/book_bloc.dart';
import '../../presentation/bloc/borrow/borrow_bloc.dart';
import '../../presentation/bloc/student/student_bloc.dart';

final GetIt sl = GetIt.instance;

void setupServiceLocator() {
  // ---- Data layer: local data sources -----------------------------------
  sl.registerLazySingleton(() => AuthLocalDataSource());
  sl.registerLazySingleton(() => BookLocalDataSource());
  sl.registerLazySingleton(() => BorrowLocalDataSource());
  sl.registerLazySingleton(() => AuthorLocalDataSource());
  sl.registerLazySingleton(() => StudentLocalDataSource());

  // ---- Data layer: repository implementations ----------------------------
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<BookRepository>(() => BookRepositoryImpl(sl()));
  // BorrowRepositoryImpl needs BookRepository too, to keep availability in sync.
  sl.registerLazySingleton<BorrowRepository>(() => BorrowRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<AuthorRepository>(() => AuthorRepositoryImpl(sl()));
  sl.registerLazySingleton<StudentRepository>(() => StudentRepositoryImpl(sl()));

  // ---- Domain layer: use cases --------------------------------------------
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => GetBooksUseCase(sl()));
  sl.registerLazySingleton(() => AddBookUseCase(sl()));
  sl.registerLazySingleton(() => UpdateBookUseCase(sl()));
  sl.registerLazySingleton(() => DeleteBookUseCase(sl()));
  sl.registerLazySingleton(() => IssueBookUseCase(sl()));
  sl.registerLazySingleton(() => ReturnBookUseCase(sl()));
  sl.registerLazySingleton(() => GetAllBorrowRecordsUseCase(sl()));
  sl.registerLazySingleton(() => GetAuthorsUseCase(sl()));
  sl.registerLazySingleton(() => AddAuthorUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAuthorUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAuthorUseCase(sl()));
  sl.registerLazySingleton(() => GetStudentsUseCase(sl()));
  sl.registerLazySingleton(() => AddStudentUseCase(sl()));
  sl.registerLazySingleton(() => UpdateStudentUseCase(sl()));
  sl.registerLazySingleton(() => DeleteStudentUseCase(sl()));

  // ---- Presentation layer: Blocs -------------------------------------------
  // All are singletons because they're provided once at the app root
  // and their state needs to stay consistent across every screen.
  sl.registerLazySingleton(() => AuthBloc(loginUseCase: sl()));
  sl.registerLazySingleton(() => BookBloc(
        getBooksUseCase: sl(),
        addBookUseCase: sl(),
        updateBookUseCase: sl(),
        deleteBookUseCase: sl(),
      ));
  sl.registerLazySingleton(() => BorrowBloc(
        getAllBorrowRecordsUseCase: sl(),
        issueBookUseCase: sl(),
        returnBookUseCase: sl(),
      ));
  sl.registerLazySingleton(() => AuthorBloc(
        getAuthorsUseCase: sl(),
        addAuthorUseCase: sl(),
        updateAuthorUseCase: sl(),
        deleteAuthorUseCase: sl(),
      ));
  sl.registerLazySingleton(() => StudentBloc(
        getStudentsUseCase: sl(),
        addStudentUseCase: sl(),
        updateStudentUseCase: sl(),
        deleteStudentUseCase: sl(),
      ));
}
