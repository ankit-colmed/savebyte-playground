import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {
  const AuthInitialState();
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthAuthenticatedState extends AuthState {
  final String userId;
  final String email;
  final String token;

  const AuthAuthenticatedState({
    required this.userId,
    required this.email,
    required this.token,
  });

  @override
  List<Object?> get props => [userId, email, token];
}

class AuthUnauthenticatedState extends AuthState {
  const AuthUnauthenticatedState();
}

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
