import 'package:attrack/bloc/auth_bloc/events/auth_event.dart';

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  AuthEventRegister(this.email, this.password);
}
