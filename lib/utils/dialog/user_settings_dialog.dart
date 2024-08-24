import 'package:attrack/models/user_model.dart';
import 'package:flutter/material.dart';

enum SettingOptions {
  editProfile,
  logout,
}

Future<SettingOptions?> showSettingsDialog(
  BuildContext context,
  UserModel user,
) {
  return showDialog<SettingOptions>(
    context: context,
    builder: (context) {
      return SimpleDialog(
        alignment: Alignment.center,
        title: Text(
          user.name,
          textAlign: TextAlign.center,
          style: TextStyle(
                color: Color(0xFF73FBFD),
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
        ),
        children: [
          CircleAvatar(
            radius: 60,
            //backgroundImage: ,
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              user.email,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF73FBFD),
                fontSize: 18,
              ),
            ),
          ),
          const Divider(),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(
              SettingOptions.editProfile,
            ),
            child: const Text(
              "Edit Profile",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(
              SettingOptions.logout,
            ),
            child: const Text(
              "LogOut",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          SimpleDialogOption(
            child: const Text(
              "Close",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
