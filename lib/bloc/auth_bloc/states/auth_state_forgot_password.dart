import 'package:attrack/bloc/auth_bloc/state_message.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state.dart';

class AuthStateForgotPassword extends AuthState {
  final bool hasSendEmail;
  final Exception? exception;
  const AuthStateForgotPassword({
    super.message,
    required this.exception,
    required this.hasSendEmail,
  });

  @override
  AuthState copyWith({StateMessage? message, bool? isloading}) {
    return AuthStateForgotPassword(
      message: message,
      exception: exception,
      hasSendEmail: hasSendEmail,
    );
  }
}
