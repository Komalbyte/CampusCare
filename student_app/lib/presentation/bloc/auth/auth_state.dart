import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state (splash screen)
class AuthInitial extends AuthState {}

/// Loading state (processing login/signup)
class AuthLoading extends AuthState {}

/// Authenticated state (user is logged in)
class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

/// Unauthenticated state (user needs to login)
class AuthUnauthenticated extends AuthState {}

/// Failure state (error occurred)
class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}
