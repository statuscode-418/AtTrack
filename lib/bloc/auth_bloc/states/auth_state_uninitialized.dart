import 'package:attrack/bloc/auth_bloc/state_message.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state.dart';

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({super.message});

  @override
  AuthState copyWith({StateMessage? message, bool? isloading}) {
    return AuthStateUninitialized(message: message);
  }
}
