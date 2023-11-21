import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoggedInState extends LoginState {
  final bool isLoggedIn;
  final bool isSessionExpired;
  const LoggedInState(this.isLoggedIn, this.isSessionExpired);

  @override
  List<Object> get props => [isLoggedIn, isSessionExpired];
}

class LoginErrorState extends LoginState {
  final String errorMessage;

  const LoginErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
