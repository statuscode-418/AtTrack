import 'package:attrack/bloc/auth_bloc/state_message.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state.dart';

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut({super.message, required this.exception});

  @override
  AuthState copyWith({StateMessage? message, bool? isloading}) {
    return AuthStateLoggedOut(message: message, exception: exception);
  }
}
