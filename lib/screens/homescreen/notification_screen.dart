import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<String> notifications = [
    "Your ticket has been confirmed.",
    "Your ticket has been confirmed.",
    "Your ticket has been confirmed.",
    "Your ticket has been confirmed.",
    "Your ticket has been confirmed.",
  ];

  NotificationScreen({super.key});

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
            const Text("Notifications", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return NotificationTile(notification: notifications[index]);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1E1E), // Dark background color
        selectedItemColor: const Color(0xFF00E0FF), // Light blue color
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
          ),
        ],
        currentIndex: 2, // Set the current index to the notifications tab
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String notification;

  const NotificationTile({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2C2C2C), // Slightly lighter dark color
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.notifications,
                color: Color(0xFF00E0FF)), // Notification icon
            const SizedBox(width: 16.0),
            Expanded(
              child: Text(
                notification,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
