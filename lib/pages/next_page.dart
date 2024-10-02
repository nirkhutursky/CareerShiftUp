import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'resume_provider.dart';

class NextPage extends StatelessWidget {
  const NextPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final workExperienceProvider = Provider.of<ResumeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Page'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: workExperienceProvider.getAllExperiences.length,
        itemBuilder: (context, index) {
          final experience = workExperienceProvider.getAllExperiences[index];
          return ListTile(
            title: Text(experience.jobTitle),
            subtitle: Text(
                '${experience.companyName} (${experience.startDate} - ${experience.endDate})'),
          );
        },
      ),
    );
  }
}
