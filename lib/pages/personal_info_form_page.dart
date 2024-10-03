// personal_info_form_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'resume_provider.dart';

class PersonalInfoFormPage extends StatelessWidget {
  const PersonalInfoFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final resumeProvider = Provider.of<ResumeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to home page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextFormField(
              label: 'Full Name (Required)',
              icon: Icons.person,
              controller: resumeProvider.fullNameController,
              isMandatory: true,
            ),
            _buildTextFormField(
              label: 'Email Address (Required)',
              icon: Icons.email,
              controller: resumeProvider.emailController,
              isMandatory: true,
            ),
            _buildTextFormField(
              label: 'Phone Number (Required)',
              icon: Icons.phone,
              controller: resumeProvider.phoneController,
              isMandatory: true,
            ),
            _buildTextFormField(
              label: 'LinkedIn Profile (Optional)',
              icon: Icons.link,
              controller: resumeProvider.linkedInController,
              isMandatory: false,
            ),
            _buildTextFormField(
              label: 'Portfolio Website (Optional)',
              icon: Icons.web,
              controller: resumeProvider.portfolioController,
              isMandatory: false,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: () {
                if (_validateInputs(resumeProvider)) {
                  Navigator.pushNamed(context, '/educationForm');
                } else {
                  _showErrorDialog(
                      context, 'Please fill in all required fields.');
                }
              },
              child:
                  const Text('Submit', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isMandatory = false,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          labelText: label,
          labelStyle: TextStyle(
            color: isMandatory && controller.text.isEmpty
                ? Colors.red
                : Colors.grey,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isMandatory && controller.text.isEmpty
                  ? Colors.red
                  : Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isMandatory && controller.text.isEmpty
                  ? Colors.red
                  : Colors.blueAccent,
            ),
          ),
          filled: true,
          fillColor: Colors.blue[50],
        ),
        onChanged: (value) {},
      ),
    );
  }

  bool _validateInputs(ResumeProvider resumeProvider) {
    return resumeProvider.fullNameController.text.isNotEmpty &&
        resumeProvider.emailController.text.isNotEmpty &&
        resumeProvider.phoneController.text.isNotEmpty;
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error', style: TextStyle(color: Colors.redAccent)),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
