import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'resume_provider.dart'; // Import ResumeProvider

class LanguagesFormPage extends StatelessWidget {
  const LanguagesFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final resumeProvider = Provider.of<ResumeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Languages Information'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ...resumeProvider.getAllLanguages.map((language) {
            int index = resumeProvider.getAllLanguages.indexOf(language);
            return _buildLanguageForm(language, index, resumeProvider);
          }).toList(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              resumeProvider.addLanguage(Language(
                languageNameController: TextEditingController(),
                proficiencyController: TextEditingController(),
              ));
            },
            child: const Text('Add Language'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageForm(
      Language language, int index, ResumeProvider resumeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Language', language.languageNameController),
              _buildTextField('Proficiency', language.proficiencyController),
              const SizedBox(height: 10),
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                onPressed: () {
                  resumeProvider.removeLanguage(index);
                },
                child: const Text('Remove Language'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
