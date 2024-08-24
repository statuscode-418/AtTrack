import 'package:attrack/bloc/auth_bloc/state_message.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  final StateMessage? message;
  const AuthState({this.message});

  @override
  List<Object> get props => [message ?? const StateMessage('')];

  AuthState copyWith({
    StateMessage? message,
    bool? isloading,
  });
}
