import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'resume_provider.dart';

class PersonalInfoFormPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final resumeProvider = Provider.of<ResumeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextFormField(
                label: 'Full Name (Required)',
                icon: Icons.person,
                controller: resumeProvider.fullNameController,
                validator: (value) =>
                    _validateName(value, 'Full Name', isRequired: true),
              ),
              _buildTextFormField(
                label: 'Email Address (Required)',
                icon: Icons.email,
                controller: resumeProvider.emailController,
                validator: (value) =>
                    _validateField(value, 'Email Address', isRequired: true),
              ),
              _buildTextFormField(
                label: 'Phone Number (Required)',
                icon: Icons.phone,
                controller: resumeProvider.phoneController,
                validator: (value) =>
                    _validatePhone(value, 'Phone Number', isRequired: true),
              ),
              _buildTextFormField(
                label: 'LinkedIn Profile (Optional)',
                icon: Icons.link,
                controller: resumeProvider.linkedInController,
                validator: (value) => _validateField(value, 'LinkedIn Profile'),
              ),
              _buildTextFormField(
                label: 'Portfolio Website (Optional)',
                icon: Icons.web,
                controller: resumeProvider.portfolioController,
                validator: (value) =>
                    _validateField(value, 'Portfolio Website'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
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
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          labelText: label,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blueAccent),
          ),
          filled: true,
          fillColor: Colors.blue[50],
        ),
        validator: validator,
      ),
    );
  }

  // Validator to ensure no dangerous characters and basic field validation
  String? _validateField(String? value, String fieldName,
      {bool isRequired = false}) {
    final dangerousCharacters = RegExp(r'[:;]');

    // Check if the field is required and empty
    if (isRequired && (value == null || value.isEmpty)) {
      return '$fieldName cannot be empty';
    }

    // Check for dangerous characters
    if (dangerousCharacters.hasMatch(value ?? '')) {
      return '$fieldName contains invalid characters (: or ;)';
    }

    return null;
  }

  // Validator for names to ensure only alphabetic characters are allowed
  String? _validateName(String? value, String fieldName,
      {bool isRequired = false}) {
    final nameRegex = RegExp(r'^[a-zA-Z ]+$'); // Allows alphabets and spaces

    // Check if the field is required and empty
    if (isRequired && (value == null || value.isEmpty)) {
      return '$fieldName cannot be empty';
    }

    // Check if name contains only letters and spaces
    if (value != null && !nameRegex.hasMatch(value)) {
      return '$fieldName can only contain alphabetic characters';
    }

    return _validateField(
        value, fieldName); // Also check for dangerous characters
  }

  // Validator for phone numbers to ensure only numeric input
  String? _validatePhone(String? value, String fieldName,
      {bool isRequired = false}) {
    final phoneRegex = RegExp(r'^[0-9]+$'); // Allows only numeric values

    // Check if the field is required and empty
    if (isRequired && (value == null || value.isEmpty)) {
      return '$fieldName cannot be empty';
    }

    // Check if phone number contains only numbers
    if (value != null && !phoneRegex.hasMatch(value)) {
      return '$fieldName can only contain numbers';
    }

    return _validateField(
        value, fieldName); // Also check for dangerous characters
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
