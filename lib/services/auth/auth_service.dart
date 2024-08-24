import 'package:attrack/services/auth/auth_provider.dart';
import 'package:attrack/services/auth/auth_user.dart';
import 'package:attrack/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  AuthService(this.provider);

  factory AuthService.firebase() => AuthService(
        FirebaseAuthProvider(),
      );

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get getCurrentUser => provider.getCurrentUser;

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) =>
      provider.login(email: email, password: password);

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> sendPasswordReset({required String toEmail}) =>
      provider.sendPasswordReset(toEmail: toEmail);

  @override
  AuthUser? get user => provider.user;

  @override
  Future<AuthUser> refreshUser(
    AuthUser user,
  ) =>
      provider.refreshUser(
        user,
      );
}
