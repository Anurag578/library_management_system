// APP ENTRY POINT
//
// setupServiceLocator() wires up the full dependency graph first. Then
// MultiBlocProvider places every Bloc above MaterialApp - the root of the
// widget tree - making them all GLOBAL. This is an admin-only app: a
// successful login always leads to AdminShell.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/author/author_bloc.dart';
import 'presentation/bloc/book/book_bloc.dart';
import 'presentation/bloc/borrow/borrow_bloc.dart';
import 'presentation/bloc/student/student_bloc.dart';
import 'presentation/pages/auth/login_page.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<BookBloc>(create: (_) => sl<BookBloc>()),
        BlocProvider<BorrowBloc>(create: (_) => sl<BorrowBloc>()),
        BlocProvider<AuthorBloc>(create: (_) => sl<AuthorBloc>()),
        BlocProvider<StudentBloc>(create: (_) => sl<StudentBloc>()),
      ],
      child: MaterialApp(
        title: 'Kutumba Library',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E5C79)),
          useMaterial3: true,
          navigationBarTheme: const NavigationBarThemeData(
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          ),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
