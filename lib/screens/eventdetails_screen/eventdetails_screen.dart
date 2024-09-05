import 'package:attrack/models/checkpoint_model.dart';
import 'package:attrack/models/event_model.dart';
import 'package:attrack/models/user_model.dart';
import 'package:attrack/screens/eventdetails_screen/eventdetails_view_model.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventModel event;
  final UserModel user;
  final DBModel db;

  const EventDetailsScreen({
    super.key,
    required this.event,
    required this.user,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          EventDetailsViewModel(event: event, user: user, db: db),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Event Details'),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Consumer<EventDetailsViewModel>(
                  builder: (context, provider, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 170,
                          foregroundDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: provider.event.photoUrl != null
                                ? DecorationImage(
                                    image:
                                        NetworkImage(provider.event.photoUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.grey[300],
                          ),
                          child: provider.event.photoUrl == null
                              ? Center(
                                  child: Icon(
                                    Icons.image,
                                    color: Colors.grey[800],
                                    size: 50,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          provider.event.title,
                          style: const TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF73FBFD),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            const Icon(Icons.calendar_month),
                            const SizedBox(width: 8.0),
                            Text(
                              DateFormat('dd MMMM yyyy hh:mm a')
                                  .format(provider.event.date),
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Icon(Icons.location_on),
                            const SizedBox(width: 8.0),
                            Text(provider.event.address,
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        const Text('Description',
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF73FBFD))),
                        const SizedBox(height: 8.0),
                        Text(
                          provider.event.description ?? '',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 16.0),
                        StreamBuilder<List<CheckpointModel>>(
                            stream: provider.getCheckpoints(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (snapshot.hasError) {
                                return const Text('Error loading checkpoints');
                              }
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Text('No checkpoints available');
                              }

                              var checkPoints = snapshot.data!;

                              return Wrap(
                                spacing: 8,
                                children: [
                                  for (var checkPoint in checkPoints)
                                    provider.user.isAdmin
                                        ? GestureDetector(
                                            onTap: () {
                                              provider.onCheckpointTap(
                                                  context, checkPoint);
                                            },
                                            child: Chip(
                                              label: Text(checkPoint.name),
                                              onDeleted: () async {
                                                await provider.deleteCheckpoint(
                                                    context,
                                                    checkPoint.checkpointId);
                                              },
                                            ),
                                          )
                                        : Chip(
                                            label: Text(checkPoint.name),
                                          ),
                                ],
                              );
                            }),
                        if (provider.user.isAdmin)
                          IconButton(
                            onPressed: () {
                              provider.addChip(context);
                            },
                            icon: const Icon(Icons.add),
                          ),
                        if (provider.user.isAdmin &&
                            provider.user.uid == provider.event.uid)
                          _buildApprovalSection(provider, context)
                        else
                          _buildRegistrationSection(provider, context),
                      ],
                    );
                  },
                ),
              ),
            ),
            _buildInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalSection(
      EventDetailsViewModel provider, BuildContext context) {
    return Container(
      color: const Color(0xFF322C2C),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Approval',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF73FBFD),
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Approval Required',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Your registration is subject to approval by the host.',
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          const Divider(
            color: Colors.white,
            thickness: 1.0,
          ),
          const Text(
            'Welcome! To join the event, please register below',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Center(
            child: ElevatedButton(
              onPressed: () => provider.navigateToApprovalScreen(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
              ),
              child: const Text(
                'Approve Registration',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 90,
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationSection(
      EventDetailsViewModel viewModel, BuildContext context) {
    return Container(
      color: const Color(0xFF322C2C),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Registration',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF73FBFD),
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Approval Required',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Your registration is subject to approval by the host.',
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          const Divider(
            color: Colors.white,
            thickness: 1.0,
          ),
          const Text(
            'Welcome! To join the event, please register below',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Center(
            child: ElevatedButton(
              onPressed: () => viewModel.joinEvent(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
              ),
              child: const Text(
                'Request to Join',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 90,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: const Color(0xFF322C2C),
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          enableSuggestions: false,
          autocorrect: false,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            label: Text(
              'Input field here',
              style: TextStyle(color: Colors.white),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
