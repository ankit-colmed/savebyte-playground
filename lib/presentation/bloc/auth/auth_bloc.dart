import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Inject use cases here when implemented
  // final LoginUseCase loginUseCase;
  // final RegisterUseCase registerUseCase;
  // final LogoutUseCase logoutUseCase;

  AuthBloc() : super(const AuthInitialState()) {
    on<AuthLoginEvent>(_onLoginEvent);
    on<AuthRegisterEvent>(_onRegisterEvent);
    on<AuthLogoutEvent>(_onLogoutEvent);
    on<AuthInitEvent>(_onInitEvent);
  }

  Future<void> _onLoginEvent(
      AuthLoginEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoadingState());
    try {
      // Call use case
      // final result = await loginUseCase.call(event.email, event.password);
      // if (result.isSuccess) {
      //   emit(AuthAuthenticatedState(...));
      // } else {
      //   emit(AuthErrorState(message: result.error));
      // }
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthAuthenticatedState(
        userId: '1',
        email: event.email,
        token: 'fake_token',
      ));
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> _onRegisterEvent(
      AuthRegisterEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoadingState());
    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthAuthenticatedState(
        userId: '1',
        email: event.email,
        token: 'fake_token',
      ));
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> _onLogoutEvent(
      AuthLogoutEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoadingState());
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(const AuthUnauthenticatedState());
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> _onInitEvent(
      AuthInitEvent event,
      Emitter<AuthState> emit,
      ) async {
    // Check if user is already authenticated
    await Future.delayed(const Duration(seconds: 1));
    emit(const AuthUnauthenticatedState());
  }
}