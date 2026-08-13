import 'package:elyx_assignment_app/core/utils/either.dart';
import 'package:elyx_assignment_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:elyx_assignment_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:elyx_assignment_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:elyx_assignment_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUseCase;
  final AuthRepository authRepository;

  AuthBloc({required this.loginUseCase, required this.authRepository})
    : super(AuthInitialState()) {
    on<LoginRequestedEvent>(_onLoginRequestedEvent);
    on<LogoutRequestedEvent>(_onLogoutRequestedEvent);
    on<AuthCheckRequestedEvent>(_onAuthCheckRequestedEvent);
    on<SessionExpiredEvent>(_onSessionExpiredEvent);
  }

  Future<void> _onLoginRequestedEvent(
    LoginRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await loginUseCase(event.username, event.password);
    
    if (result is Left) {
      emit(AuthErrorState((result as Left).value.message));
    } else {
      emit(AuthAuthenticatedState());
    }
  }

  Future<void> _onLogoutRequestedEvent(
    LogoutRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    await authRepository.logout();
    emit(AuthUnauthenticatedState());
  }

  Future<void> _onAuthCheckRequestedEvent(
    AuthCheckRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    final isLoggedIn = await authRepository.isLoggedIn();
    emit(isLoggedIn ? AuthAuthenticatedState() : AuthUnauthenticatedState());
  }

  Future<void> _onSessionExpiredEvent(
    SessionExpiredEvent event,
    Emitter<AuthState> emit,
  ) async {
    await authRepository.logout();  
    emit(const AuthErrorState('Session expired. Please login again.'));
    emit(AuthUnauthenticatedState());
  }
}
