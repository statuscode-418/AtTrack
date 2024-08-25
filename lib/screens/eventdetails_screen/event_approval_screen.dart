import 'package:attrack/models/form_submission.dart';
import 'package:flutter/material.dart';

class EventApprovalScreen extends StatefulWidget {
  const EventApprovalScreen({super.key});

  @override
  State<EventApprovalScreen> createState() => _EventApprovalScreenState();
}

class _EventApprovalScreenState extends State<EventApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Approval'),
      ),
      // body: StreamBuilder<List<FormSubmission>>(
      //     stream: getSubmissions(), builder: builder)
    );
  }
}
