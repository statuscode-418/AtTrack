import 'package:attrack/models/user_model.dart';
import 'package:attrack/services/qr_service/qr_parser.dart';
import 'package:flutter/foundation.dart';

class UserDetailsQrViewModel extends ChangeNotifier {
  final UserModel user;
  late String userCredString;

  UserDetailsQrViewModel({required this.user}) {
    userCredString = QrParser.encodeUid(user.uniqueCode);
  }
}
