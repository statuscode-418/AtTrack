import 'package:attrack/bloc/auth_bloc/state_message.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state.dart';
import 'package:attrack/models/user_model.dart';

class AuthStateShowUserDetailsForm extends AuthState {
  final UserModel user;
  final Function(UserModel) onSubmit;
  final String? error;

  const AuthStateShowUserDetailsForm({
    super.message,
    required this.user,
    required this.onSubmit,
    this.error,
  });

  @override
  AuthState copyWith({StateMessage? message, bool? isloading}) {
    return AuthStateShowUserDetailsForm(
      user: user,
      onSubmit: onSubmit,
      error: error,
    );
  }
}
