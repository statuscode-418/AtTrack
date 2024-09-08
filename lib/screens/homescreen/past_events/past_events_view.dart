import 'package:attrack/components/eventcard.dart';
import 'package:attrack/models/user_model.dart';
import 'package:attrack/screens/homescreen/past_events/past_events_view_model.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PastEventsView extends StatelessWidget {
  final UserModel user;
  final DBModel db;

  const PastEventsView({
    super.key,
    required this.user,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PastEventsViewModel(user: user, db: db),
      child: Consumer<PastEventsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.events == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.events!.isEmpty) {
            return const Center(
              child: Text('No events found'),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Past Events',
                    style: TextStyle(
                      fontSize: 30,
                      color: Color(0xFF73FBFD),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: ListView.builder(
                      itemCount: viewModel.events!.length,
                      itemBuilder: (context, index) {
                        final event = viewModel.events![index];
                        return EventCard(
                          user: viewModel.user,
                          event: event,
                          onTap: () =>
                              viewModel.navigateToEventDetails(context, event),
                        );
                      },
                    ),
                  ),
                  if (viewModel.isAdmin)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SizedBox(
                          width: 300,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan,
                            ),
                            onPressed: () =>
                                viewModel.navigateToCreateEvent(context),
                            child: const Text(
                              'Create Meeting',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
