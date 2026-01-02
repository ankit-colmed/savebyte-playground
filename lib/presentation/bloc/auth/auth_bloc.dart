import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/usecases/register_usecase.dart';
import '../../../domain/usecases/logout_usecase.dart';
import '../../../domain/usecases/get_logged_in_user_usecase.dart';
import '../../../domain/usecases/is_logged_in_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetLoggedInUserUseCase _getLoggedInUserUseCase;
  final IsLoggedInUseCase _isLoggedInUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetLoggedInUserUseCase getLoggedInUserUseCase,
    required IsLoggedInUseCase isLoggedInUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _getLoggedInUserUseCase = getLoggedInUserUseCase,
        _isLoggedInUseCase = isLoggedInUseCase,
        super(const AuthInitialState()) {
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
      final user = await _loginUseCase.call(event.email, event.password);

      if (user != null) {
        emit(AuthAuthenticatedState(
          userId: user.id,
          email: user.email,
          token: user.token,
        ));
      } else {
        emit(const AuthErrorState(message: 'Login failed'));
      }
    } catch (e) {
      emit(AuthErrorState(message: _getErrorMessage(e)));
    }
  }

  Future<void> _onRegisterEvent(
      AuthRegisterEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoadingState());
    try {
      final user = await _registerUseCase.call(
        event.name,
        event.email,
        event.password,
      );

      if (user != null) {
        emit(AuthAuthenticatedState(
          userId: user.id,
          email: user.email,
          token: user.token,
        ));
      } else {
        emit(const AuthErrorState(message: 'Registration failed'));
      }
    } catch (e) {
      emit(AuthErrorState(message: _getErrorMessage(e)));
    }
  }

  Future<void> _onLogoutEvent(
      AuthLogoutEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoadingState());
    try {
      await _logoutUseCase.call();
      emit(const AuthUnauthenticatedState());
    } catch (e) {
      emit(AuthErrorState(message: _getErrorMessage(e)));
    }
  }

  Future<void> _onInitEvent(
      AuthInitEvent event,
      Emitter<AuthState> emit,
      ) async {
    try {
      final isLoggedIn = await _isLoggedInUseCase.call();

      if (isLoggedIn) {
        final user = await _getLoggedInUserUseCase.call();
        if (user != null) {
          emit(AuthAuthenticatedState(
            userId: user.id,
            email: user.email,
            token: user.token,
          ));
        } else {
          emit(const AuthUnauthenticatedState());
        }
      } else {
        emit(const AuthUnauthenticatedState());
      }
    } catch (e) {
      emit(const AuthUnauthenticatedState());
    }
  }

  String _getErrorMessage(dynamic error) {
    return error.toString().replaceAll('Exception: ', '');
  }
}