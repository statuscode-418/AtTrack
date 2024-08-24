import 'package:attrack/bloc/auth_bloc/state_message.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state.dart';

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({super.message});

  @override
  AuthState copyWith({StateMessage? message, bool? isloading}) {
    return AuthStateNeedsVerification(message: message);
  }
}
