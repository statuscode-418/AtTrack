import 'package:bloc/bloc.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_add_user_details.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_forgot_password.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_initialize.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_login.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_logout.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_register.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_send_email_verification.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_should_register.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_show_update_user_details.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_update_user_details.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_verify_email.dart';
import 'package:attrack/bloc/auth_bloc/state_message.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state_forgot_password.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state_logged_in.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state_logged_out.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state_needs_verification.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state_registering.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state_show_user_details_form.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state_uninitialized.dart';
import 'package:attrack/models/user_model.dart';
import 'package:attrack/services/auth/auth_provider.dart';
import 'package:attrack/services/auth/firebase_auth_provider.dart';
import 'package:attrack/services/firestore_storage/firestore_db_exceptions.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  BuildContext context;

  AuthBloc(this.context, AuthProvider authProvider, DBModel dbProvider)
      : super(const AuthStateUninitialized(
          message: StateMessage(
            'Auth State uninitialized',
            isError: true,
          ),
        )) {
    on<AuthEventInitialize>((event, emit) async {
      await authProvider.initialize();
      await dbProvider.init();
      final authUser = await (authProvider as FirebaseAuthProvider)
          .getCurrentUserWithDetails();
      if (authUser == null) {
        emit(const AuthStateLoggedOut(
          exception: null,
          message: StateMessage(
            'Please wait till we initialize',
            isError: false,
          ),
        ));
      } else if (!authUser.isEmailVerified) {
        emit(const AuthStateNeedsVerification(
          message: StateMessage(
            'Please verify your email',
            isError: false,
          ),
        ));
      } else {
        var dbUser = await dbProvider.getUser(authUser.id);
        if (dbUser == null) {
          var uniqueCode = const Uuid().v4();
          dbUser = UserModel.newUser(
            uid: authUser.id,
            email: authUser.email,
            uniqueCode: uniqueCode,
          );
          emit(AuthStateShowUserDetailsForm(
            user: dbUser,
            message: const StateMessage(
              'Provide all the user field',
              isError: false,
            ),
            onSubmit: (u) => add(
              AuthEventAddUserDetails(user: u),
            ),
          ));
          return;
        }
        emit(AuthStateLoggedIn(
          authUser: authUser,
          dbUser: dbUser,
          dbProvider: dbProvider,
          message: const StateMessage(
            'Logged in',
            isError: false,
          ),
        ));
      }
    });

    on<AuthEventShouldRegister>(
      (event, emit) {
        emit(const AuthStateRegistering(
            exception: null,
            message: StateMessage(
              'Register Event',
              isError: false,
            )));
      },
    );

    on<AuthEventLogout>((event, emit) async {
      try {
        await authProvider.logout();
        emit(const AuthStateLoggedOut(
            exception: null,
            message: StateMessage(
              'Logging you out',
              isError: false,
            )));
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
              exception: e,
              message: const StateMessage(
                'Loggin you out',
                isError: false,
              )),
        );
      }
    });

    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await authProvider.createUser(
          email: email,
          password: password,
        );
        await authProvider.sendEmailVerification();
        emit(
          const AuthStateNeedsVerification(
            message: StateMessage(
              'Verifing email',
              isError: false,
            ),
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateRegistering(
            exception: e,
            message: const StateMessage(
              'Registering you in',
              isError: false,
            ),
          ),
        );
      }
    });

    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        message: StateMessage(
          'Click here to reset your password',
          isError: false,
        ),
        exception: null,
        hasSendEmail: false,
      ));
      final email = event.email;
      if (email == null) {
        return;
      }

      emit(
        const AuthStateForgotPassword(
            exception: null,
            hasSendEmail: false,
            message: StateMessage(
              'Please provide your registered email to recieve a password verification link',
              isError: true,
            )),
      );
      bool didSendEmail;
      Exception? exception;

      try {
        await authProvider.sendPasswordReset(toEmail: email);
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
      }
      emit(AuthStateForgotPassword(
        message: const StateMessage(
          'A password reset mail has been send to your provided email',
          isError: false,
        ),
        exception: exception,
        hasSendEmail: didSendEmail,
      ));
    });

    on<AuthEventSendEmailVerification>((event, emit) async {
      await authProvider.sendEmailVerification();
      emit(state);
    });

    on<AuthEventLogin>(
      (event, emit) async {
        emit(const AuthStateLoggedOut(
          exception: null,
          message: StateMessage(
            'Please wait while we log you in',
            isError: true,
          ),
        ));

        final email = event.email;
        final password = event.password;

        try {
          final authUser = await authProvider.login(
            email: email,
            password: password,
          );
          if (!authUser.isEmailVerified) {
            emit(const AuthStateLoggedOut(
              exception: null,
              message: StateMessage(
                'Please verify your email before login',
                isError: false,
              ),
            ));
            emit(const AuthStateNeedsVerification(
              message: StateMessage(
                'Please verify your email',
                isError: false,
              ),
            ));
          } else if (authUser.isEmailVerified) {
            var dbUser = await dbProvider.getUser(authUser.id);
            if (dbUser == null) {
              var uniqueCode = const Uuid().v4();
              dbUser = UserModel.newUser(
                uid: authUser.id,
                email: authUser.email,
                uniqueCode: uniqueCode,
              );
              emit(
                AuthStateShowUserDetailsForm(
                  user: dbUser,
                  onSubmit: (u) => add(
                    AuthEventAddUserDetails(user: u),
                  ),
                ),
              );
              return;
            }
            emit(AuthStateLoggedIn(
              message: const StateMessage('Login Succesfully'),
              dbUser: dbUser,
              dbProvider: dbProvider,
              authUser: authUser,
            ));
          } else {
            emit(const AuthStateLoggedOut(
              exception: null,
              message: StateMessage(
                'Something went wrong while loggin',
                isError: false,
              ),
            ));
          }
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(
              exception: e,
              message: StateMessage(
                e.toString(),
                isError: false,
              )));
        }
      },
    );
    on<AuthEventAddUserDetails>(
      (event, emit) async {
        try {
          var authUser = authProvider.getCurrentUser!;
          var user = event.user;

          await dbProvider.createUser(user);
          emit(AuthStateLoggedIn(
            dbUser: user,
            authUser: authUser,
            dbProvider: dbProvider,
            message: const StateMessage(
              'Add User Details',
              isError: false,
            ),
          ));
        } on FirestoreDBExceptions catch (e) {
          emit(state.copyWith(
            message: StateMessage(
              e.toString(),
            ),
          ));
        } catch (e) {
          emit(state.copyWith(
            message: StateMessage(
              e.toString(),
            ),
          ));
        }
      },
    );

    on<AuthEventShowUpdateUserDetails>(
      (event, emit) {
        emit(AuthStateShowUserDetailsForm(
          user: event.user,
          onSubmit: (user) => add(
            AuthEventUpdateUserDetails(
              user: user,
            ),
          ),
        ));
      },
    );

    on<AuthEventUpdateUserDetails>((event, emit) {
      var user = event.user;
      dbProvider.updateUser(user);
      emit(AuthStateLoggedIn(
        dbUser: user,
        authUser: authProvider.getCurrentUser!,
        dbProvider: dbProvider,
        message: const StateMessage(
          'Logging you in',
          isError: false,
        ),
      ));
    });

    on<AuthEventVerifyEmail>((event, emit) async {
      var authuser = authProvider.user;
      if (authuser == null) {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            message: StateMessage('User not found', isError: true),
          ),
        );
        return;
      }
      emit(
        const AuthStateNeedsVerification(
          message: StateMessage(
            'Verify your email',
            isError: false,
          ),
        ),
      );
      try {
        authuser = authProvider.getCurrentUser;
        if (authuser == null) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              message: StateMessage('User not found', isError: true),
            ),
          );
          return;
        }
        authuser = await authProvider.refreshUser(authuser);
        if (!authuser.isEmailVerified) {
          emit(const AuthStateNeedsVerification(
            message: StateMessage(
              'Verify your email',
              isError: false,
            ),
          ));
          return;
        }
        var user = await dbProvider.getUser(authuser.id);
        if (user == null) {
          var uniqueCode = const Uuid().v4();
          user = UserModel.newUser(
            uid: authuser.id,
            email: authuser.email,
            uniqueCode: uniqueCode,
          );
          emit(AuthStateShowUserDetailsForm(
            user: user,
            onSubmit: (u) => add(
              AuthEventAddUserDetails(user: u),
            ),
          ));
          return;
        }
        emit(
          AuthStateLoggedIn(
            dbUser: user,
            authUser: authuser,
            dbProvider: dbProvider,
          ),
        );
      } on Exception catch (e) {
        emit(AuthStateNeedsVerification(
          message: StateMessage(
            e.toString(),
            isError: false,
          ),
        ));
      }
    });
  }
}
