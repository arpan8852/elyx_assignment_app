import 'package:elyx_assignment_app/core/di/injection_container.dart';
import 'package:elyx_assignment_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:elyx_assignment_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:elyx_assignment_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:elyx_assignment_app/features/auth/presentation/pages/login_page.dart';
import 'package:elyx_assignment_app/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:elyx_assignment_app/features/transactions/presentation/pages/transaction_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>()..add(AuthCheckRequestedEvent()),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        home: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticatedState) {
              navigatorKey.currentState?.pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const InitialAuthCheck()),
                (route) => false,
              );
            }
          },
          child: const InitialAuthCheck(),
        ),
      ),
    );
  }
}

class InitialAuthCheck extends StatelessWidget {
  const InitialAuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoadingState || state is AuthInitialState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is AuthAuthenticatedState) {
          return BlocProvider<TransactionBloc>(
            create: (_) => sl<TransactionBloc>(),
            child: const TransactionListPage(),
          );
        }
        return const LoginPage();
      },
    );
  }
}
