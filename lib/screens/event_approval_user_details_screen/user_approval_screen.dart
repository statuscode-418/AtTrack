import 'package:attrack/models/form_submission.dart';
import 'package:attrack/models/user_model.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:attrack/utils/dialog/show_generic_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_approval_view_model.dart';

class UserApprovalScreen extends StatelessWidget {
  final UserModel user;
  final FormSubmission submission;
  final DBModel db;

  const UserApprovalScreen({
    super.key,
    required this.user,
    required this.submission,
    required this.db,
  });

  void _showDisapproveDialog(
      BuildContext context, UserApprovalViewModel viewModel) {
    showGenericDialog(
      context: context,
      title: 'Disapprove User',
      content: 'Are you sure you want to disapprove this user?',
      optionsBuilder: () => {
        'Disapprove': true,
        'Cancel': false,
      },
    ).then((value) {
      if (value == true) {
        viewModel.disapproveUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserApprovalViewModel(
        db: db,
        user: user,
        submission: submission,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Approval'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<UserApprovalViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 100,
                          backgroundImage:
                              user.photoUrl != null && user.photoUrl!.isNotEmpty
                                  ? NetworkImage(user.photoUrl!)
                                  : null,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Name: ${user.name}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Email: ${user.email}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Github: ${user.github}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Linkedin: ${user.linkedin}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Instagram: ${user.instagram}',
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
                        onPressed: () {
                          if (viewModel.submission.accepted) {
                            _showDisapproveDialog(context, viewModel);
                          } else {
                            viewModel.approveUser();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: viewModel.submission.accepted
                              ? Colors.red
                              : Colors.green,
                        ),
                        child: Text(viewModel.submission.accepted
                            ? 'Disapprove'
                            : 'Approve'),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
