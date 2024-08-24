import 'package:attrack/bloc/auth_bloc/state_message.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state.dart';
import 'package:attrack/models/user_model.dart';
import 'package:attrack/services/auth/auth_user.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';

class AuthStateLoggedIn extends AuthState {
  final AuthUser authUser;
  final UserModel dbUser;
  final DBModel dbProvider;
  const AuthStateLoggedIn({
    super.message,
    required this.dbUser,
    required this.authUser,
    required this.dbProvider,
  });

  @override
  AuthState copyWith({StateMessage? message, bool? isloading}) {
    return AuthStateLoggedIn(
      message: message,
      dbUser: dbUser,
      dbProvider: dbProvider,
      authUser: authUser,
    );
  }
}
