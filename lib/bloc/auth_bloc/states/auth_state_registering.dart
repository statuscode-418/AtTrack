import 'package:attrack/bloc/auth_bloc/state_message.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state.dart';

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({
    required this.exception,
    super.message,
  });

  @override
  AuthState copyWith({StateMessage? message, bool? isloading}) {
    return AuthStateRegistering(exception: exception, message: message);
  }
}
