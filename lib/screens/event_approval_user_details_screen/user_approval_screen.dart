import 'package:attrack/models/form_submission.dart';
import 'package:attrack/models/user_model.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:attrack/utils/dialog/show_generic_dialog.dart';
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
  void _showDisapproveDialog() {
    showGenericDialog(
      context: context,
      title: 'Disapprove User',
      content: 'Are you sure you want to disapprove this user',
      optionsBuilder: () => {
        'Disapprove': true,
        'Cancel': false,
      },
    ).then((value) {
      if (value == true) {
        var newSubmission = widget.submission.copyWith(accepted: false);
        widget.db.updateSubmission(newSubmission).then((_) {
          setState(() {
            widget.submission.accepted = newSubmission.accepted;
          });
        });
      }
    });
  }

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
                  if (widget.submission.accepted) {
                    _showDisapproveDialog();
                  } else {
                    var newSubmission =
                        widget.submission.copyWith(accepted: true);
                    await widget.db.updateSubmission(newSubmission);
                    setState(() {
                      widget.submission.accepted = newSubmission.accepted;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      widget.submission.accepted ? Colors.red : Colors.green,
                ),
                child:
                    Text(widget.submission.accepted ? 'Disapprove' : 'Approve'),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
