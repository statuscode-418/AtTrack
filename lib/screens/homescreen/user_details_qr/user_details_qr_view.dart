import 'package:attrack/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_bar_code/qr/src/qr_code.dart';
import 'user_details_qr_view_model.dart'; // Import the ViewModel

class UserDetailsQrView extends StatelessWidget {
  final UserModel user;
  const UserDetailsQrView({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserDetailsQrViewModel(user: user),
      child: Consumer<UserDetailsQrViewModel>(
        builder: (context, viewModel, child) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: QRCode(
                data: viewModel.userCredString,
                backgroundColor: const Color(0xFF73FBFD),
              ),
            ),
          );
        },
      ),
    );
  }
}
