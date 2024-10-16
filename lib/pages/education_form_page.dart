import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'resume_provider.dart';
import 'shared_layout.dart'; // Import the shared layout

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  _EducationFormPageState createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  bool _allEducationEntriesSaved(ResumeProvider resumeProvider) {
    return resumeProvider.getAllEducation
        .every((education) => education.isSaved);
  }

  @override
  Widget build(BuildContext context) {
    final resumeProvider = Provider.of<ResumeProvider>(context);

    return SharedLayout(
      child: Scaffold(
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
                      onPressed: _allEducationEntriesSaved(resumeProvider)
                          ? () {
                              // Add new education entry at the top
                              setState(() {
                                resumeProvider.addEducationAtTop(
                                  Education(
                                    isExpanded:
                                        true, // Only new entry is expanded
                                  ),
                                );
                              });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _allEducationEntriesSaved(resumeProvider)
                                ? Colors.blueAccent[400]
                                : Colors.grey,
                      ),
                      child: const Text('Add Education',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _allEducationEntriesSaved(resumeProvider)
                          ? () {
                              Navigator.pushNamed(context, '/skillsForm');
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _allEducationEntriesSaved(resumeProvider)
                                ? Colors.greenAccent[400]
                                : Colors.grey,
                      ),
                      child: const Text('Submit Education',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildEducationList(resumeProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEducationList(ResumeProvider resumeProvider) {
    return ListView.builder(
      itemCount: resumeProvider.getAllEducation.length,
      itemBuilder: (context, index) {
        final education = resumeProvider.getAllEducation[index];
        return EducationPanel(
          key: ValueKey(education.id),
          education: education,
        );
      },
    );
  }
}

class EducationPanel extends StatefulWidget {
  final Education education;

  const EducationPanel({
    super.key,
    required this.education,
  });

  @override
  _EducationPanelState createState() => _EducationPanelState();
}

class _EducationPanelState extends State<EducationPanel> {
  @override
  Widget build(BuildContext context) {
    final education = widget.education;
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);

    return Card(
      key: ValueKey(education.id),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              education.schoolNameController.text.isEmpty
                  ? 'Education'
                  : education.schoolNameController.text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: Icon(
                  education.isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  education.isExpanded = !education.isExpanded;
                });
              },
            ),
          ),
          if (education.isExpanded)
            _buildEducationForm(education, resumeProvider),
        ],
      ),
    );
  }

  Widget _buildEducationForm(
      Education education, ResumeProvider resumeProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildTextField(
            label: 'School Name (Required)',
            controller: education.schoolNameController,
            isMandatory: true,
          ),
          const SizedBox(height: 10),
          _buildDropdownField(
            label: 'Degree (Required)',
            currentValue: education.degreeController.text,
            items: const [
              'High School',
              'Diploma',
              'BSc',
              'MSc',
              'PhD',
              'Other',
            ],
            onChanged: (value) {
              setState(() {
                education.degreeController.text = value ?? 'Other';
              });
            },
          ),
          const SizedBox(height: 10),
          _buildTextField(
            label: 'Field of Study (Optional)',
            controller: education.fieldOfStudyController,
            isMandatory: false,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildYearPickerField(
                  label: 'Start Year (Required)',
                  controller: education.startYearController,
                  isMandatory: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildYearPickerField(
                  label: 'End Year (Required)',
                  controller: education.endYearController,
                  isMandatory: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent[400],
            ),
            onPressed: () {
              if (_validateEducationEntry(education)) {
                setState(() {
                  education.isSaved = true;
                  education.isExpanded = false; // Collapse panel after saving
                });
                resumeProvider.notifyListeners(); // Notify the provider
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Education entry saved successfully!')),
                );
              } else {
                _showErrorDialog(context, 'Please fill all required fields!');
              }
            },
            child: const Text('Save Education Entry',
                style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent[200],
            ),
            onPressed: () {
              setState(() {
                resumeProvider.removeEducationById(education.id);
              });
            },
            child: const Text('Remove Education Entry',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
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

  Widget _buildDropdownField({
    required String label,
    required String currentValue,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: currentValue.isNotEmpty ? currentValue : null,
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
      validator: (value) {
        return _validateField(value, label, true);
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
          validator: (value) {
            return _validateYearField(controller.text, label);
          },
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

  String? _validateField(String? value, String label, bool isMandatory) {
    if (isMandatory && (value == null || value.trim().isEmpty)) {
      return '$label is required';
    }

    if (label == 'Field of Study (Optional)' &&
        value != null &&
        value.isNotEmpty &&
        !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Only alphabetic characters are allowed for Field of Study';
    }

    if (value != null && RegExp(r'[:;]').hasMatch(value)) {
      return '$label contains invalid characters';
    }

    return null;
  }

  String? _validateYearField(String value, String label) {
    if (value.isEmpty) {
      return '$label is required';
    }
    final int? year = int.tryParse(value);
    if (year == null || year < 1950 || year > DateTime.now().year) {
      return 'Invalid $label';
    }
    return null;
  }

  bool _validateEducationEntry(Education education) {
    final String schoolName = education.schoolNameController.text.trim();
    final String degree = education.degreeController.text.trim();
    final String startYear = education.startYearController.text.trim();
    final String endYear = education.endYearController.text.trim();

    if (schoolName.isEmpty ||
        degree.isEmpty ||
        startYear.isEmpty ||
        endYear.isEmpty) {
      _showErrorDialog(context, 'Please fill all required fields!');
      return false;
    }

    final int? startYearInt = int.tryParse(startYear);
    final int? endYearInt = int.tryParse(endYear);

    if (startYearInt == null || endYearInt == null) {
      _showErrorDialog(context, 'Please enter valid years.');
      return false;
    }

    if (startYearInt > endYearInt) {
      _showErrorDialog(context, 'End year cannot be before start year.');
      return false;
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
