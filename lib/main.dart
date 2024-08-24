import 'package:attrack/screens/auth_screens/email_verification_view.dart';
import 'package:attrack/screens/auth_screens/forgot_password_screen.dart';
import 'package:attrack/screens/auth_screens/login_screen.dart';
import 'package:attrack/screens/auth_screens/register_screen.dart';
import 'package:attrack/bloc/auth_bloc/auth_bloc.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_initialize.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state_forgot_password.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state_logged_in.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state_logged_out.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state_needs_verification.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state_registering.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state_show_user_details_form.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state_uninitialized.dart';
import 'package:attrack/screens/homescreen/home_screen.dart';
import 'package:attrack/screens/shared/loading_screen.dart';
import 'package:attrack/screens/user_details_view.dart';

import 'package:attrack/services/auth/firebase_auth_provider.dart';
import 'package:attrack/services/firestore_storage/firestore_db.dart';
import 'package:attrack/shared/loading/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(
        context,
        FirebaseAuthProvider(),
        FirestoreDB(),
      ),
      child: const AuthBlocHandler(),
    ));
  }
}

class AuthBlocHandler extends StatelessWidget {
  const AuthBlocHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.message != null && state.message!.isError) {
          return LoadingDialog().show(
            context: context,
            text: state.message?.message ?? 'Please wait a moment',
          );
        } else {
          LoadingDialog().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateUninitialized) {
          context.read<AuthBloc>().add(const AuthEventInitialize());
          return const LoadingScreen();
        }
        if (state is AuthStateLoggedIn) {
          // Need to test it later
          return HomeScreen(
            user: state.dbUser,
            dbprovider: state.dbProvider,
            isLoading: state.message?.isError != null,
            error: state.message?.message,
          );
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginScreen();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterScreen();
        } else if (state is AuthStateShowUserDetailsForm) {
          return UserDetailsView(
            user: state.user,
            onSubmit: state.onSubmit,
          );
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
