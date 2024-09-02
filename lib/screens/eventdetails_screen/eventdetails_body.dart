import 'package:attrack/models/checkpoint_model.dart';
import 'package:attrack/screens/eventapproval_screen/event_approval_screen.dart';
import 'package:attrack/screens/eventdetails_screen/eventdetails_provider.dart';
import 'package:attrack/screens/scanning/scanning_screen.dart';
import 'package:attrack/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventDetailsBody extends StatelessWidget {
  const EventDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventDetailsProvider>(context);

    return Stack(children: [
      Positioned.fill(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 170,
                foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: provider.event.photoUrl != null
                      ? DecorationImage(
                          image: NetworkImage(provider.event.photoUrl!),
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
                          fontSize: 16.0, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text('Description',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: ttertiaryColor)),
              const SizedBox(height: 8.0),
              Text(
                provider.event.description ?? '',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              StreamBuilder<List<CheckpointModel>>(
                  stream: provider.db.getCheckpoints(provider.event.eid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return const Text('Error loading checkpoints');
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No checkpoints available');
                    }

                    var checkPonts = snapshot.data!;

                    return Wrap(
                      spacing: 8,
                      children: [
                        for (var checkPoint in checkPonts)
                          provider.user.isAdmin
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return ScanningScreen(
                                          checkpointModel: checkPoint,
                                          db: provider.db,
                                          eventModel: provider.event,
                                        );
                                      },
                                    ));
                                  },
                                  child: Chip(
                                    label: Text(checkPoint.name),
                                    onDeleted: () async {
                                      try {
                                        await provider.db.deleteCheckpoint(
                                            checkPoint.checkpointId);
                                      } catch (e) {
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Failed to delete checkpoint: $e'),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                )
                              : Chip(
                                  label: Text(checkPoint.name),
                                ),
                        const SizedBox(
                          height: 70,
                        )
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
                Container(
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
                          color: ttertiaryColor,
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
                          onPressed: () {
                            // Add your onPressed code here!
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return EventApprovalScreen(
                                  db: provider.db,
                                  event: provider.event,
                                );
                              },
                            ));
                          },
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
                      )
                    ],
                  ),
                )
              else
                Container(
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
                          color: ttertiaryColor,
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
                          onPressed: () => provider.joinEvent(context),
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
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      Positioned(
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
              label: Text('Ask your doubts here',
                  style: TextStyle(color: Colors.white)),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.cyan),
              ),
              suffixIcon:
                  Icon(Icons.question_answer_outlined, color: Colors.white),
            ),
          ),
        ),
      ),
    ]);
  }
}
