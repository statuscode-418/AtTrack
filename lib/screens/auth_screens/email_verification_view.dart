// ignore_for_file: use_build_context_synchronously

import 'package:attrack/bloc/auth_bloc/auth_bloc.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_logout.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_send_email_verification.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_verify_email.dart';
import 'package:attrack/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CircleAvatar(
              radius: 60,
              //backgroundImage: AssetImage('assets/images/avatar.png'),
            ),
            const SizedBox(height: 30),
            const Text(
                'A verification email has been sent to your email address.',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const Text("Please verify to continue!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 30),
            SizedBox(
              width: 300,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                ),
                child: const Text('Verify Email',
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                onPressed: () async {
                  context.read<AuthBloc>().add(
                        const AuthEventVerifyEmail(),
                      );
                },
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(
                      const AuthEventSendEmailVerification(),
                    );
              },
              child: const Text(
                'Did not got the email? click here to resend',
                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().logout();
                context.read<AuthBloc>().add(
                      const AuthEventLogout(),
                    );
              },
              child: const Text('Wrong email? click here to logout',
                  style: TextStyle(color: Colors.cyan, fontSize: 18),
                  textAlign: TextAlign.center),
            )
          ],
        ),
      ),
    );
  }
}
