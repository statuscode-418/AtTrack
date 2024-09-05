import 'package:attrack/screens/event_approval_user_details_screen/user_approval_screen.dart';
import 'package:attrack/screens/eventapproval_screen/event_approval_view_model.dart';
import 'package:attrack/screens/shared/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:attrack/models/event_model.dart';
import 'package:attrack/models/user_model.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:provider/provider.dart';

class EventApprovalScreen extends StatelessWidget {
  final DBModel db;
  final EventModel event;

  const EventApprovalScreen({
    super.key,
    required this.db,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => EventApprovalViewModel(db: db, eventId: event.eid),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Event Approval'),
          ),
          body: Consumer<EventApprovalViewModel>(
              builder: (context, viewModel, child) {
            if (viewModel.submissions == null) {
              return const LoadingScreen();
            } else if (viewModel.submissions!.isEmpty) {
              return const Center(
                child: Text('No submissions found'),
              );
            } else {
              return ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                itemCount: viewModel.submissions!.length,
                itemBuilder: (context, index) {
                  final submission = viewModel.submissions![index];
                  return FutureBuilder<UserModel?>(
                    future: viewModel.getUserByCode(submission.userCode),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const ListTile(
                          title: Text('Loading user...'),
                        );
                      } else if (userSnapshot.hasError) {
                        return ListTile(
                          title: Text('Error: ${userSnapshot.error}'),
                        );
                      } else if (!userSnapshot.hasData) {
                        return const ListTile(
                          title: Text('User not found'),
                        );
                      } else {
                        final user = userSnapshot.data!;
                        return ListTile(
                          title: Text(user.name),
                          trailing: submission.accepted
                              ? const Text(
                                  "Accepted",
                                  style: TextStyle(color: Colors.green),
                                )
                              : const Text(
                                  'Yet to be approved',
                                  style: TextStyle(color: Colors.red),
                                ),
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return UserApprovalScreen(
                                user: user,
                                submission: submission,
                                db: db,
                              );
                            },
                          )),
                        );
                      }
                    },
                  );
                },
              );
            }
          }),
        ));
  }
}
