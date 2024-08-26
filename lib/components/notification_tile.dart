import 'package:attrack/utils/colors.dart';
import 'package:flutter/material.dart';

import '../utils/dialog/show_generic_dialog.dart';

class NotificationTile extends StatelessWidget {
  final String profileImageUrl;
  final String senderName;
  final String notificationContent;

  const NotificationTile({
    super.key,
    required this.profileImageUrl,
    required this.senderName,
    required this.notificationContent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        showGenericDialog(
          title: senderName,
          context: context,
          content: notificationContent,
          optionsBuilder: () {
            return {
              'Close': null,
            };
          },
        );
      } ,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            const CircleAvatar(
              //backgroundImage: NetworkImage(profileImageUrl),
              radius: 24.0,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    senderName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: ttertiaryColor,
                    ),
                  ),
                  const SizedBox(height: 1.0),
                  Text(
                    notificationContent,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
