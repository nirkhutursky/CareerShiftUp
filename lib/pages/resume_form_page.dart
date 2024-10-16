import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shared_layout.dart'; // Import the shared layout
import 'resume_provider.dart';

class ResumeFormPage extends StatefulWidget {
  const ResumeFormPage({super.key});

  @override
  _ResumeFormPageState createState() => _ResumeFormPageState();
}

class _ResumeFormPageState extends State<ResumeFormPage> {
  final _formKey = GlobalKey<FormState>();

  bool _allExperiencesSaved(ResumeProvider resumeProvider) {
    return resumeProvider.getAllExperiences
        .every((experience) => experience.isSaved);
  }

  @override
  Widget build(BuildContext context) {
    final resumeProvider = Provider.of<ResumeProvider>(context);

    return SharedLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Resume Builder - Work Experience'),
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigate back to personal info page
            },
          ),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Add and Submit buttons side by side
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _allExperiencesSaved(resumeProvider)
                          ? () {
                              // Add new experience at the top
                              resumeProvider.addExperienceAtTop(
                                WorkExperience(
                                  jobTitleController: TextEditingController(),
                                  companyController: TextEditingController(),
                                  startDateController: TextEditingController(),
                                  endDateController: TextEditingController(),
                                  descriptionController:
                                      TextEditingController(),
                                  isExpanded:
                                      true, // Ensure new experience is expanded
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _allExperiencesSaved(resumeProvider)
                            ? Colors.blueAccent[400]
                            : Colors.grey,
                      ),
                      child: const Text('Add Work Experience',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _allExperiencesSaved(resumeProvider)
                          ? () {
                              Navigator.pushNamed(context, '/summaryPage');
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _allExperiencesSaved(resumeProvider)
                            ? Colors.greenAccent[400]
                            : Colors.grey,
                      ),
                      child: const Text('Submit Work Experiences',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: resumeProvider.getAllExperiences.length,
                  itemBuilder: (context, index) {
                    final experience = resumeProvider.getAllExperiences[index];
                    return WorkExperiencePanel(
                      key: ValueKey(experience.id),
                      experience: experience,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WorkExperiencePanel extends StatefulWidget {
  final WorkExperience experience;

  const WorkExperiencePanel({
    super.key,
    required this.experience,
  });

  @override
  _WorkExperiencePanelState createState() => _WorkExperiencePanelState();
}

class _WorkExperiencePanelState extends State<WorkExperiencePanel> {
  @override
  Widget build(BuildContext context) {
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);
    final experience = widget.experience;

    return Card(
      key: ValueKey(experience.id),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              experience.jobTitleController.text.isEmpty
                  ? 'Work Experience'
                  : experience.jobTitleController.text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: Icon(experience.isExpanded
                  ? Icons.expand_less
                  : Icons.expand_more),
              onPressed: () {
                setState(() {
                  experience.isExpanded = !experience.isExpanded;
                });
              },
            ),
          ),
          if (experience.isExpanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTextFormField(
                    label: 'Job Title (Required)',
                    controller: experience.jobTitleController,
                    isMandatory: true,
                  ),
                  const SizedBox(height: 10),
                  _buildTextFormField(
                    label: 'Company Name (Required)',
                    controller: experience.companyController,
                    isMandatory: true,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildYearPickerField(
                          label: 'Start Year (Required)',
                          controller: experience.startDateController,
                          isMandatory: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildYearPickerField(
                          label: 'End Year (Required)',
                          controller: experience.endDateController,
                          isMandatory: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildTextFormField(
                    label: 'Role Description (Optional)',
                    controller: experience.descriptionController,
                    isMandatory: false,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent[400],
                    ),
                    onPressed: () {
                      if (_validateExperienceInputs(experience, context)) {
                        setState(() {
                          experience.isSaved = true;
                          experience.isExpanded = false;
                        });
                        resumeProvider.notifyListeners();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Work experience saved successfully!')),
                        );
                      } else {
                        _showErrorDialog(
                            context, 'Please fill all required fields!');
                      }
                    },
                    child: const Text('Save Work Experience',
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent[200],
                    ),
                    onPressed: () {
                      resumeProvider.removeExperienceById(experience.id);
                    },
                    child: const Text('Remove Work Experience',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required TextEditingController controller,
    bool isMandatory = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        labelStyle: TextStyle(
          color:
              isMandatory && controller.text.isEmpty ? Colors.red : Colors.grey,
        ),
      ),
      validator: (value) {
        return _validateField(value, label, isMandatory);
      },
    );
  }

  Widget _buildYearPickerField({
    required String label,
    required TextEditingController controller,
    bool isMandatory = false,
  }) {
    return InkWell(
      onTap: () async {
        await _selectYear(context, controller);
      },
      child: IgnorePointer(
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
            suffixIcon:
                const Icon(Icons.calendar_today, color: Colors.blueAccent),
          ),
          enabled: false, // Disable manual typing
        ),
      ),
    );
  }

  Future<void> _selectYear(
      BuildContext context, TextEditingController controller) async {
    int? selectedYear = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Year'),
          content: SizedBox(
            height: 200,
            width: 300,
            child: YearPicker(
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
              initialDate: DateTime.now(),
              selectedDate: DateTime.now(),
              onChanged: (DateTime dateTime) {
                Navigator.pop(context, dateTime.year);
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (selectedYear != null) {
      setState(() {
        controller.text = selectedYear.toString();
      });
    }
  }

  bool _validateExperienceInputs(
      WorkExperience experience, BuildContext context) {
    // Validate the job title first
    String? jobTitleError =
        _validateAlphabeticField(experience.jobTitle, 'Job Title');
    if (jobTitleError != null) {
      _showErrorDialog(context, jobTitleError);
      return false; // Stop further validation once an error is found
    }

    // Validate the company name next
    String? companyNameError =
        _validateAlphabeticField(experience.companyName, 'Company Name');
    if (companyNameError != null) {
      _showErrorDialog(context, companyNameError);
      return false; // Stop further validation once an error is found
    }

    // Additional validation for start and end dates
    if (experience.startDate.isEmpty || experience.endDate.isEmpty) {
      _showErrorDialog(context, 'Please fill in all required fields.');
      return false;
    }

    int? startYear = int.tryParse(experience.startDate);
    int? endYear = int.tryParse(experience.endDate);

    if (startYear == null || endYear == null) {
      _showErrorDialog(context, 'Please enter valid years.');
      return false;
    }

    if (endYear < startYear) {
      _showErrorDialog(context, 'End year cannot be before start year.');
      return false;
    }

    return true; // If all checks pass, the input is valid
  }

  String? _validateField(String? value, String label, bool isMandatory) {
    if (isMandatory && (value == null || value.trim().isEmpty)) {
      return '$label is required';
    }

    return null;
  }

  String? _validateAlphabeticField(String? value, String fieldName) {
    final alphabeticRegex =
        RegExp(r'^[a-zA-Z\s]+$'); // Allow only alphabetic chars

    // If the field is empty, return the empty field error
    if (value == null || value.trim().isEmpty) {
      return '$fieldName cannot be empty';
    }

    // If there are illegal characters, return the illegal characters error
    if (!alphabeticRegex.hasMatch(value.trim())) {
      return '$fieldName can only contain alphabetic characters';
    }

    return null; // No validation error
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
