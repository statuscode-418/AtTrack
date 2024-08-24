import 'package:flutter/material.dart';
import '../../components/notification_tile.dart';

class NotificationScreen extends StatelessWidget {

  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Dark background color
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E), // Match the background color
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title:
            const Text("Notifications", style: TextStyle(color: Color(0xFF73FBFD))),
      ),
      body:  const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NotificationTile(
            profileImageUrl: 'https://example.com/profile.jpg',
            senderName: 'Rohan Mitra',
            notificationContent: 'Your application has been approved.Please confirm your ticket to assure ur presence',
          ),
          NotificationTile(
            profileImageUrl: 'https://example.com/profile.jpg',
            senderName: 'Rohan Mitra',
            notificationContent: 'Your application has been approved.Please confirm your ticket to assure ur presence jhnfjksfncjkfcnwjkc jcnwjkcfnwjkcnewjkn ndcjkwncjkwncwjduewih ncwjkcnwhwekh',
          ),
          NotificationTile(
            profileImageUrl: 'https://example.com/profile.jpg',
            senderName: 'Rohan Mitra',
            notificationContent: 'Your application has been approved.Please confirm your ticket to assure ur presence nabansdjkcnjcn sdbcwhcwui sjkdbcnwjkbnc',
          ),
        ],
      ),
    ),
    );
  }
}

