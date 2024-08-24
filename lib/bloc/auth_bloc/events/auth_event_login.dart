import 'package:attrack/bloc/auth_bloc/events/auth_event.dart';

class AuthEventLogin extends AuthEvent {
  final String email;
  final String password;
  AuthEventLogin(this.email, this.password);
}
