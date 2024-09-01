import 'package:attrack/models/form_submission.dart';
import 'package:attrack/models/user_model.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:flutter/material.dart';

class UserApprovalScreen extends StatefulWidget {
  final UserModel user;
  final FormSubmission submission;
  final DBModel db;
  const UserApprovalScreen(
      {super.key,
      required this.user,
      required this.submission,
      required this.db});

  @override
  State<UserApprovalScreen> createState() => _UserApprovalScreenState();
}

class _UserApprovalScreenState extends State<UserApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Approval'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: widget.user.photoUrl != null &&
                            widget.user.photoUrl!.isNotEmpty
                        ? NetworkImage(widget.user.photoUrl!)
                        : null,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Name: ${widget.user.name}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Email: ${widget.user.email}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Github: ${widget.user.github}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Linkedin: ${widget.user.linkedin}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Instagram: ${widget.user.instagram}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
              ],
            ),
            Center(
                child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  var newSubmission =
                      widget.submission.copyWith(accepted: true);
                  await widget.db.updateSubmission(newSubmission);
                },
                child: const Text('Approval'),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
