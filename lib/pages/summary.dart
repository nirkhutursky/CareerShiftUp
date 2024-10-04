import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'resume_provider.dart';
import 'shared_layout.dart'; // Import shared layout

class Summary extends StatelessWidget {
  const Summary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final resumeProvider = Provider.of<ResumeProvider>(context);

    return SharedLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Summary'),
          backgroundColor: Colors.blueAccent,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Personal Information'),
              _buildPersonalInfoSection(resumeProvider),
              const SizedBox(height: 20),
              _buildSectionTitle('Work Experience'),
              _buildWorkExperienceSection(resumeProvider),
              const SizedBox(height: 20),
              _buildSectionTitle('Education'),
              _buildEducationSection(resumeProvider),
              const SizedBox(height: 20),
              _buildSectionTitle('Skills'),
              _buildSkillsSection(resumeProvider),
              const SizedBox(height: 20),
              _buildSectionTitle('Languages'),
              _buildLanguagesSection(resumeProvider),
            ],
          ),
        ),
      ),
    );
  }

  // Section for Personal Info
  Widget _buildPersonalInfoSection(ResumeProvider provider) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Full Name', provider.fullNameController.text),
            _buildInfoRow('Email', provider.emailController.text),
            _buildInfoRow('Phone', provider.phoneController.text),
            _buildInfoRow('LinkedIn', provider.linkedInController.text),
            _buildInfoRow('Portfolio', provider.portfolioController.text),
          ],
        ),
      ),
    );
  }

  // Section for Work Experience
  Widget _buildWorkExperienceSection(ResumeProvider provider) {
    return provider.getAllExperiences.isEmpty
        ? const Text('No work experience added.')
        : Column(
            children: provider.getAllExperiences.map((experience) {
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(experience.jobTitle.isNotEmpty
                      ? experience.jobTitle
                      : 'Job Title not specified'),
                  subtitle: Text(
                      '${experience.companyName} (${experience.startDate} - ${experience.endDate})'),
                ),
              );
            }).toList(),
          );
  }

  // Section for Education
  Widget _buildEducationSection(ResumeProvider provider) {
    return provider.getAllEducation.isEmpty
        ? const Text('No education added.')
        : Column(
            children: provider.getAllEducation.map((education) {
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(education.schoolNameController.text.isNotEmpty
                      ? education.schoolNameController.text
                      : 'School Name not specified'),
                  subtitle: Text(
                      '${education.degreeController.text}, ${education.startYearController.text} - ${education.endYearController.text}'),
                ),
              );
            }).toList(),
          );
  }

  // Section for Skills
  Widget _buildSkillsSection(ResumeProvider provider) {
    return provider.getAllSkills.isEmpty
        ? const Text('No skills added.')
        : Column(
            children: provider.getAllSkills.map((skill) {
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(skill.skillController.text.isNotEmpty
                      ? skill.skillController.text
                      : 'Skill not specified'),
                  subtitle:
                      Text('Proficiency: ${skill.proficiencyController.text}'),
                ),
              );
            }).toList(),
          );
  }

  // Section for Languages
  Widget _buildLanguagesSection(ResumeProvider provider) {
    return provider.getAllLanguages.isEmpty
        ? const Text('No languages added.')
        : Column(
            children: provider.getAllLanguages.map((language) {
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(language.languageNameController.text.isNotEmpty
                      ? language.languageNameController.text
                      : 'Language not specified'),
                  subtitle: Text(
                      'Proficiency: ${language.proficiencyController.text}'),
                ),
              );
            }).toList(),
          );
  }

  // Utility method to build section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
      ),
    );
  }

  // Utility method to build rows of information
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(value.isNotEmpty ? value : 'Not specified'),
          ),
        ],
      ),
    );
  }
}
