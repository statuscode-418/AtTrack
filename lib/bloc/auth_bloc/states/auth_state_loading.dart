import 'package:attrack/bloc/auth_bloc/state_message.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state.dart';

class AuthStateLoading extends AuthState {
  const AuthStateLoading({super.message});

  @override
  AuthState copyWith({StateMessage? message, bool? isloading}) {
    return AuthStateLoading(message: message);
  }
}
