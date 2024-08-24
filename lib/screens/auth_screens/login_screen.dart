import 'package:attrack/bloc/auth_bloc/auth_bloc.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_forgot_password.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_login.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_should_register.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state.dart';
import 'package:attrack/bloc/auth_bloc/states/auth_state_logged_out.dart';
import 'package:attrack/services/auth/auth_exceptions.dart';
import 'package:attrack/shared/snackbar/show_snackbar.dart';
//import 'package:attrack/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  final RegExp emailValid = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthStateLoggedOut) {
            if (state.exception is UserNotFoundAuthException) {
              await showSnackbar(context, 'User not found');
            } else if (state.exception is WrongPasswordAuthException) {
              await showSnackbar(
                  context, 'Cannot find a user with the credentials');
            } else if (state.exception is WrongPasswordAuthException) {
              await showSnackbar(context, 'Wrong Credentials');
            } else if (state.exception is GenericAuthException) {
              await showSnackbar(context, 'Authentication failed');
            }
          }
        },
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Form(
              key: _formKey,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const CircleAvatar(
                        radius: 60,
                        //backgroundImage: AssetImage('assets/images/avatar.png'),
                      ),
                      const SizedBox(height: 30),
                      const Text('Welcome Back..',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        enableSuggestions: false,
                        autocorrect: false,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          label: Text('Email',
                              style: TextStyle(color: Colors.white)),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
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
                        height: 10,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        textInputAction: TextInputAction.next,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          label: Text('Password',
                              style: TextStyle(color: Colors.white)),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                                color: Colors
                                    .cyan), // Change this to your desired color
                          ),
                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid password';
                          } else if (value.length < 6) {
                            return "Password must be at least of 6 characters";
                          } else {
                            return null;
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                    const AuthEventForgotPassword(),
                                  );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style:
                                  TextStyle(color: Colors.cyan, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 300,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan,
                          ),
                          child: const Text('Login',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final email = _emailController.text;
                              final password = _passwordController.text;
                              context.read<AuthBloc>().add(
                                    AuthEventLogin(email, password),
                                  );
                            }
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                const AuthEventShouldRegister(),
                              );
                        },
                        child: const Text(
                            'Don\'t have an account? Register here',
                            style: TextStyle(color: Colors.cyan, fontSize: 15)),
                      ),
                    ],
                  ),
                ),
              )),
            )));
  }
}
