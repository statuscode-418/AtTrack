import 'package:attrack/bloc/auth_bloc/events/auth_event.dart';

class AuthEventForgotPassword extends AuthEvent {
  final String? email;
  const AuthEventForgotPassword({this.email});
}
