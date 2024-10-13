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
  List<bool> _isExpandedList = [];

  @override
  void initState() {
    super.initState();
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);
    _syncExpansionState(resumeProvider);
  }

  // Sync _isExpandedList with the number of work experiences in the provider
  void _syncExpansionState(ResumeProvider resumeProvider) {
    setState(() {
      _isExpandedList = List<bool>.filled(
        resumeProvider.getAllExperiences.length,
        true,
        growable: true,
      );
    });
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              _buildWorkExperiencePanelList(resumeProvider),
              _buildAddExperienceButton(resumeProvider),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: resumeProvider.getAllExperiences
                        .any((experience) => !experience.isSaved)
                    ? null
                    : () {
                        Navigator.pushNamed(context, '/summaryPage');
                      },
                child: const Text('Submit Work Experiences',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkExperiencePanelList(ResumeProvider resumeProvider) {
    if (_isExpandedList.length < resumeProvider.getAllExperiences.length) {
      int difference =
          resumeProvider.getAllExperiences.length - _isExpandedList.length;
      _isExpandedList.addAll(
          List<bool>.filled(difference, true)); // Expand new panels by default
    } else if (_isExpandedList.length >
        resumeProvider.getAllExperiences.length) {
      _isExpandedList =
          _isExpandedList.sublist(0, resumeProvider.getAllExperiences.length);
    }

    return ExpansionPanelList(
      elevation: 1,
      expandedHeaderPadding: const EdgeInsets.all(8),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isExpandedList[index] = !_isExpandedList[index];
        });
      },
      children:
          List.generate(resumeProvider.getAllExperiences.length, (int index) {
        final experience = resumeProvider.getAllExperiences[index];
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                experience.jobTitleController.text.isEmpty
                    ? 'Work Experience ${index + 1}'
                    : experience.jobTitleController.text,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildTextFormField(
                  label: 'Job Title (Required)',
                  icon: Icons.work,
                  controller: experience.jobTitleController,
                  isMandatory: true,
                  context: context,
                ),
                _buildTextFormField(
                  label: 'Company Name (Required)',
                  icon: Icons.business,
                  controller: experience.companyController,
                  isMandatory: true,
                  context: context,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildYearPickerField(
                        label: 'Start Year (Required)',
                        controller: experience.startDateController,
                        context: context,
                        isMandatory: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildYearPickerField(
                        label: 'End Year (Required)',
                        controller: experience.endDateController,
                        context: context,
                        isMandatory: true,
                      ),
                    ),
                  ],
                ),
                _buildTextFormField(
                  label: 'Role Description (Optional)',
                  icon: Icons.description,
                  controller: experience.descriptionController,
                  isMandatory: false,
                  context: context,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent[400],
                  ),
                  onPressed: () {
                    if (_validateExperienceInputs(experience, context)) {
                      setState(() {
                        experience.isSaved = true;
                        _isExpandedList[index] = false; // Collapse the panel
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Work experience saved successfully!')),
                      );
                    }
                  },
                  child: const Text('Save Work Experience',
                      style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  onPressed: () {
                    setState(() {
                      resumeProvider.removeExperience(index);
                      _isExpandedList.removeAt(index);
                    });
                  },
                  child: const Text('Remove Work Experience'),
                ),
              ],
            ),
          ),
          isExpanded: _isExpandedList[index],
        );
      }),
    );
  }

  Widget _buildAddExperienceButton(ResumeProvider resumeProvider) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.greenAccent[400],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {
        setState(() {
          resumeProvider.addExperience(
            WorkExperience(
              jobTitleController: TextEditingController(),
              companyController: TextEditingController(),
              startDateController: TextEditingController(),
              endDateController: TextEditingController(),
              descriptionController: TextEditingController(),
            ),
          );
          _isExpandedList.add(true); // Expand the new panel by default
        });
      },
      child: const Text('Add Work Experience',
          style: TextStyle(color: Colors.black)),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required BuildContext context,
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
        validator: (value) {
          return _validateAlphabeticField(value, label);
        },
        onChanged: (value) {
          setState(() {}); // Update UI
        },
      ),
    );
  }

  Widget _buildYearPickerField({
    required String label,
    required TextEditingController controller,
    required BuildContext context,
    bool isMandatory = false,
  }) {
    return InkWell(
      onTap: () async {
        await _selectYear(context, controller);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: IgnorePointer(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon:
                  const Icon(Icons.calendar_today, color: Colors.blueAccent),
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
              filled: true,
              fillColor: Colors.blue[50],
            ),
            enabled: false, // Disable manual typing
          ),
        ),
      ),
    );
  }

  Future<void> _selectYear(
      BuildContext context, TextEditingController controller) async {
    int? selectedYear = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int currentYear = DateTime.now().year;
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
            TextButton(
              onPressed: () {
                Navigator.pop(context, currentYear);
              },
              child: const Text('Confirm'),
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

  bool _validateInputs(ResumeProvider resumeProvider) {
    bool allValid = true;
    for (var experience in resumeProvider.getAllExperiences) {
      if (!experience.isSaved) {
        allValid = false;
        break;
      }
    }
    return allValid;
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
