import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// App started event - check current session
class AppStarted extends AuthEvent {}

/// Login requested event
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

/// Signup requested event
class SignupRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String phoneNumber;
  final String rollNumber;
  final String department;
  final int year;

  const SignupRequested({
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
    required this.rollNumber,
    required this.department,
    required this.year,
  });

  @override
  List<Object> get props => [email, password, name, phoneNumber, rollNumber, department, year];
}

/// Logged out event
class LoggedOut extends AuthEvent {}
