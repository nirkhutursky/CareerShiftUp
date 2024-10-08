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
  List<bool> _isExpandedList = [];
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  void initState() {
    super.initState();
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);
    _isExpandedList = List<bool>.filled(
      resumeProvider.getAllEducation.length,
      true,
      growable: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final resumeProvider = Provider.of<ResumeProvider>(context);

    // Wrapping the entire content in SharedLayout
    return SharedLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Education Information'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Form(
          // Wrap fields in a Form
          key: _formKey, // Assign the form key for validation
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              // Build list of education fields
              _buildEducationPanelList(resumeProvider),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    // Add a new education entry
                    setState(() {
                      resumeProvider.addEducation(Education(
                        schoolNameController: TextEditingController(),
                        degreeController: TextEditingController(),
                        fieldOfStudyController: TextEditingController(),
                        startYearController: TextEditingController(),
                        endYearController: TextEditingController(),
                      ));
                      _isExpandedList.add(true); // Expand the new entry
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // Set the button color
                  ),
                  child: const Text('Add Education',
                      style: TextStyle(color: Colors.white))),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Force validation when submitting the form
                  if (_formKey.currentState!.validate()) {
                    if (_validateEducation(resumeProvider)) {
                      Navigator.pushNamed(context, '/skillsForm');
                    }
                  } else {
                    _showErrorDialog(
                        context, 'Please fill in all required fields.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Set the button color
                ),
                child: const Text('Submit Education',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEducationPanelList(ResumeProvider resumeProvider) {
    if (_isExpandedList.length < resumeProvider.getAllEducation.length) {
      int difference =
          resumeProvider.getAllEducation.length - _isExpandedList.length;
      _isExpandedList.addAll(
          List<bool>.filled(difference, true)); // Expand new panels by default
    } else if (_isExpandedList.length > resumeProvider.getAllEducation.length) {
      _isExpandedList =
          _isExpandedList.sublist(0, resumeProvider.getAllEducation.length);
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
          List.generate(resumeProvider.getAllEducation.length, (int index) {
        final education = resumeProvider.getAllEducation[index];
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                education.schoolNameController.text.isEmpty
                    ? 'Education ${index + 1}'
                    : education.schoolNameController.text,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildTextField(
                  label: 'School Name (Required)',
                  controller: education.schoolNameController,
                  isMandatory: true,
                ),
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
                _buildTextField(
                  label: 'Field of Study (Optional)',
                  controller: education.fieldOfStudyController,
                  isMandatory: false,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildYearPickerField(
                        label: 'Start Year (Required)',
                        controller: education.startYearController,
                        context: context,
                        isMandatory: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildYearPickerField(
                        label: 'End Year (Required)',
                        controller: education.endYearController,
                        context: context,
                        isMandatory: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent[400],
                  ),
                  onPressed: () {
                    // Force validation before saving the entry
                    if (_formKey.currentState!.validate() &&
                        _validateEducationEntry(education)) {
                      setState(() {
                        education.isSaved = true;
                        _isExpandedList[index] = false; // Collapse the panel
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Education entry saved successfully!')),
                      );
                    } else {
                      _showErrorDialog(
                          context, 'Please fill all required fields!');
                    }
                  },
                  child: const Text('Save Education Entry',
                      style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      resumeProvider.removeEducation(index);
                      _isExpandedList.removeAt(index);
                    });
                  },
                  child: const Text('Remove Education Entry'),
                ),
              ],
            ),
          ),
          isExpanded: _isExpandedList[index],
        );
      }),
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
        validator: (value) {
          return _validateField(value, label);
        },
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String currentValue,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
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
          return _validateField(value, label);
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
              border: const OutlineInputBorder(),
            ),
            enabled: false, // Disable manual typing
            validator: (value) {
              return _validateYearField(controller.text, label);
            },
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

  String? _validateField(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    if (label == 'Field of Study (Optional)' &&
        !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Only alphabetic characters are allowed for Field of Study';
    }
    if (RegExp(r'[:;]').hasMatch(value)) {
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
    final String startYear = education.startYearController.text;
    final String endYear = education.endYearController.text;

    if (int.tryParse(startYear)! > int.tryParse(endYear)!) {
      _showErrorDialog(context, 'End year cannot be before start year');
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

  bool _validateEducation(ResumeProvider resumeProvider) {
    bool allValid = true;
    for (var education in resumeProvider.getAllEducation) {
      if (!education.isSaved || !_validateEducationEntry(education)) {
        allValid = false;
        break;
      }
    }
    return allValid;
  }
}
