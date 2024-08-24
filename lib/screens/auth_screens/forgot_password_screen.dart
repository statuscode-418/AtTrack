// ignore_for_file: use_build_context_synchronously

import 'package:attrack/bloc/auth_bloc/auth_bloc.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_forgot_password.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_logout.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state_forgot_password.dart';
import 'package:attrack/shared/snackbar/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  final RegExp emailValid = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  @override
  initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSendEmail) {
            _controller.clear();
            await showSnackbar(context, 'Password reset link sent');
          }
          if (state.exception != null) {
            await showSnackbar(
                context, 'Please check your credentials, and try again');
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Change Your Password...',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                  autocorrect: false,
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    label: Text('Email for Password Change',
                        style: TextStyle(color: Colors.white)),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email can't be empty";
                    } else if (!emailValid.hasMatch(value)) {
                      return "Invalid email provided";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 300,
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      final email = _controller.text;
                      context.read<AuthBloc>().add(
                            AuthEventForgotPassword(email: email),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                    ),
                    child: const Text('Send Verification Code',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventLogout(),
                        );
                  },
                  child: const Text('Return to home screen',
                      style: TextStyle(color: Colors.cyan, fontSize: 15)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
