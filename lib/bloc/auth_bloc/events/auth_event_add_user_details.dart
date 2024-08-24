import 'package:attrack/models/user_model.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event.dart';

class AuthEventAddUserDetails extends AuthEvent {
  final UserModel user;

  const AuthEventAddUserDetails({required this.user});
}
