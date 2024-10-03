import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'resume_provider.dart'; // Ensure this import is correct

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({Key? key}) : super(key: key);

  @override
  _EducationFormPageState createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  @override
  Widget build(BuildContext context) {
    final resumeProvider = Provider.of<ResumeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Education Information'),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // List of education fields
          ...resumeProvider.getAllEducation.map((education) {
            int index = resumeProvider.getAllEducation.indexOf(education);
            return _buildEducationForm(education, index, resumeProvider);
          }).toList(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Add a new education entry
              resumeProvider.addEducation(Education(
                schoolNameController: TextEditingController(),
                degreeController: TextEditingController(),
                fieldOfStudyController: TextEditingController(),
                startYearController: TextEditingController(),
                endYearController: TextEditingController(),
              ));
            },
            child: const Text('Add Education'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: () {
              if (_validateEducation(resumeProvider)) {
                Navigator.pushNamed(
                    context, '/skillsForm'); // Navigate to SkillsForm
              } else {
                _showErrorDialog(
                    context, 'Please fill in all required fields.');
              }
            },
            child: const Text('Submit Education',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationForm(
      Education education, int index, ResumeProvider resumeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                label: 'School Name',
                controller: education.schoolNameController,
                isMandatory: true,
              ),
              _buildTextField(
                label: 'Degree',
                controller: education.degreeController,
                isMandatory: true,
              ),
              _buildTextField(
                label: 'Field of Study',
                controller: education.fieldOfStudyController,
                isMandatory: true,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Start Year',
                      controller: education.startYearController,
                      isMandatory: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(
                      label: 'End Year',
                      controller: education.endYearController,
                      isMandatory: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () {
                  setState(() {
                    resumeProvider.removeEducation(index);
                  });
                },
                child: const Text('Remove Education'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isMandatory = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          labelStyle: TextStyle(
            color: isMandatory && controller.text.isEmpty
                ? Colors.red
                : Colors.grey,
          ),
        ),
      ),
    );
  }

  bool _validateEducation(ResumeProvider resumeProvider) {
    for (var education in resumeProvider.getAllEducation) {
      if (education.schoolNameController.text.isEmpty ||
          education.degreeController.text.isEmpty ||
          education.fieldOfStudyController.text.isEmpty ||
          education.startYearController.text.isEmpty ||
          education.endYearController.text.isEmpty) {
        return false;
      }
    }
    return true;
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
