import 'package:elyx_assignment_app/core/network/api_client.dart';
import 'package:elyx_assignment_app/core/network/api_service.dart';
import 'package:elyx_assignment_app/core/storage/secure_storage_service.dart';
import 'package:elyx_assignment_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:elyx_assignment_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:elyx_assignment_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:elyx_assignment_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:elyx_assignment_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:elyx_assignment_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:elyx_assignment_app/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:elyx_assignment_app/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:elyx_assignment_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:elyx_assignment_app/features/transactions/domain/usecases/get_transactions_usecase.dart';
import 'package:elyx_assignment_app/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  sl.registerLazySingleton<ApiService>(() => ApiService());

  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      secureStorageService: sl(),
      onUnauthorized: () {
        sl<AuthBloc>().add(SessionExpiredEvent());
      },
    ),
  );
  // ---------------- AUTH DEPENDENCIES ----------------
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDataSourceImpl(mockApiService: sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () =>
        AuthRepositoryImpl(remoteDataSource: sl(), secureStorageService: sl()),
  );

  sl.registerLazySingleton<LoginUsecase>(() => LoginUsecase(repository: sl()));

  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(loginUseCase: sl(), authRepository: sl()),
  );

  // ---------------- TRASCACTION DEPENDENCIES ----------------
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(apiService: sl()),
  );

  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<GetTransactionsUseCase>(
    () => GetTransactionsUseCase(repository: sl()),
  );

   sl.registerFactory<TransactionBloc>(
    () => TransactionBloc(getTransactionsUseCase: sl()),
  );
}
