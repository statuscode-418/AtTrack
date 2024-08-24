import 'package:attrack/bloc/auth_bloc/events/auth_event.dart';
import 'package:attrack/models/user_model.dart';

class AuthEventUpdateUserDetails extends AuthEvent {
  final UserModel user;

  const AuthEventUpdateUserDetails({required this.user});
}
