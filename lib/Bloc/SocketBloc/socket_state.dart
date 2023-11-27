import 'package:equatable/equatable.dart';

// States
abstract class SocketState extends Equatable {
  const SocketState();

  @override
  List<Object?> get props => [];
}

class SocketConnectingState extends SocketState {}

class SocketConnectedState extends SocketState {}

class SocketDisconnectedState extends SocketState {}

class UserConnected extends SocketState {
  final String connectedUser;
  const UserConnected(this.connectedUser);

  @override
  List<Object> get props => [connectedUser];
}

class UserDisonnected extends SocketState {
  final String disconnectedUser;
  const UserDisonnected(this.disconnectedUser);

  @override
  List<Object> get props => [disconnectedUser];
}

class UserTyping extends SocketState {
  final bool isTyping;
  const UserTyping(this.isTyping);

  @override
  List<Object> get props => [isTyping];
}
