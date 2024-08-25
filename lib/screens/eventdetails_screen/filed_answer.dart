import 'package:attrack/models/form_field_answer.dart';
import 'package:flutter/material.dart';

class FieldAnswerCard extends StatelessWidget {
  final Future<List<FieldAnswer>> futureAnswers;

  const FieldAnswerCard({super.key, required this.futureAnswers});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FieldAnswer>>(
      future: futureAnswers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text('No fields present'));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final answers = snapshot.data!;
          final filteredAnswers = answers
              .where(
                  (answer) => answer.label == 'name' || answer.label == 'email')
              .toList();
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: filteredAnswers.map((answer) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('${answer.label}: ${answer.answer}'),
                  );
                }).toList(),
              ),
            ),
          );
        } else {
          return const Center(child: Text('No Data'));
        }
      },
    );
  }
}
