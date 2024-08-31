import 'package:attrack/models/user_model.dart';
import 'package:attrack/services/qr_service/qr_parser.dart';
import 'package:flutter/material.dart';
import 'package:qr_bar_code/qr/src/qr_code.dart';

class UserDetailsQrView extends StatelessWidget {
  final UserModel user;
  const UserDetailsQrView({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    var userCredString = QrParser.encodeUid(user.uniqueCode);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: QRCode(
          data: userCredString,
          backgroundColor: const Color(0xFF73FBFD),
        ),
      ),
    );
  }
}
