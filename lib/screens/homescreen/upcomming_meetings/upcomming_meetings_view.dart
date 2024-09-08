import 'package:attrack/models/user_model.dart';
import 'package:attrack/screens/eventdetails_screen/eventdetails_screen.dart';
import 'package:attrack/screens/homescreen/upcomming_meetings/upcomming_meeting_view_model.dart';
import 'package:attrack/screens/shared/loading_screen.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../components/eventcard.dart';

// ignore: must_be_immutable
class UpcommingMeetingsView extends StatelessWidget {
  UserModel user;
  final DBModel db;

  UpcommingMeetingsView({
    super.key,
    required this.user,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UpcommingMeetingViewModel(user: user, db: db),
      child: Consumer<UpcommingMeetingViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.events == null) {
            return const LoadingScreen();
          } else if (viewModel.events!.isEmpty) {
            return const Text('No events found');
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Upcoming Events',
                    style: TextStyle(
                      fontSize: 30,
                      color: Color(0xFF73FBFD),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: ListView.builder(
                      itemCount: viewModel.events?.length,
                      itemBuilder: (context, index) {
                        final event = viewModel.events?[index];
                        return EventCard(
                          user: user,
                          event: event!,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EventDetailsScreen(
                                  event: event,
                                  user: user,
                                  db: db,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
