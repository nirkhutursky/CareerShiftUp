import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'resume_provider.dart'; // Import ResumeProvider

class LanguagesFormPage extends StatefulWidget {
  const LanguagesFormPage({Key? key}) : super(key: key);

  @override
  _LanguagesFormPageState createState() => _LanguagesFormPageState();
}

class _LanguagesFormPageState extends State<LanguagesFormPage> {
  List<bool> _isExpandedList = [];

  @override
  void initState() {
    super.initState();
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);
    _isExpandedList = List<bool>.filled(
      resumeProvider.getAllLanguages.length,
      true,
      growable: true,
    );
  }

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
          // Build list of language fields
          _buildLanguagePanelList(resumeProvider),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                resumeProvider.addLanguage(Language(
                  languageNameController: TextEditingController(),
                  proficiencyController: TextEditingController(),
                ));
                _isExpandedList.add(true); // Expand the new entry
              });
            },
            child: const Text('Add Language'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: () {
              if (_validateLanguages(resumeProvider)) {
                Navigator.pushNamed(
                    context, '/resumeForm'); // Navigate to resume form
              } else {
                _showErrorDialog(
                    context, 'Please fill in all required fields.');
              }
            },
            child: const Text('Submit Languages',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguagePanelList(ResumeProvider resumeProvider) {
    if (_isExpandedList.length < resumeProvider.getAllLanguages.length) {
      int difference =
          resumeProvider.getAllLanguages.length - _isExpandedList.length;
      _isExpandedList.addAll(
          List<bool>.filled(difference, true)); // Expand new panels by default
    } else if (_isExpandedList.length > resumeProvider.getAllLanguages.length) {
      _isExpandedList =
          _isExpandedList.sublist(0, resumeProvider.getAllLanguages.length);
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
          List.generate(resumeProvider.getAllLanguages.length, (int index) {
        final language = resumeProvider.getAllLanguages[index];
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                language.languageNameController.text.isEmpty
                    ? 'Language ${index + 1}'
                    : language.languageNameController.text,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2, // Give more space to the language name field
                      child: _buildTextField(
                        'Language (Required)',
                        language.languageNameController,
                        isMandatory: true,
                      ),
                    ),
                    const SizedBox(width: 10), // Space between fields
                    Expanded(
                      flex: 1, // Less space for the proficiency dropdown
                      child: _buildProficiencyDropdown(language),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent[400],
                  ),
                  onPressed: () {
                    if (_validateLanguageEntry(language)) {
                      setState(() {
                        language.isSaved = true;
                        _isExpandedList[index] = false; // Collapse the panel
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Language entry saved successfully!')),
                      );
                    } else {
                      _showErrorDialog(
                          context, 'Please fill all required fields!');
                    }
                  },
                  child: const Text('Save Language Entry',
                      style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  onPressed: () {
                    setState(() {
                      resumeProvider.removeLanguage(index);
                      _isExpandedList.removeAt(index);
                    });
                  },
                  child: const Text('Remove Language Entry'),
                ),
              ],
            ),
          ),
          isExpanded: _isExpandedList[index],
        );
      }),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isMandatory = false}) {
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

  Widget _buildProficiencyDropdown(Language language) {
    const List<String> proficiencyLevels = [
      'Beginner',
      'Intermediate',
      'Advanced',
      'Fluent'
    ];

    return DropdownButtonFormField<String>(
      value: language.proficiencyController.text.isNotEmpty
          ? language.proficiencyController.text
          : proficiencyLevels[0], // Default to 'Beginner'
      decoration: InputDecoration(
        labelText: 'Proficiency (Required)',
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.blue[50],
        contentPadding: const EdgeInsets.symmetric(
            vertical: 14.0, horizontal: 10.0), // Align with TextField height
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
      onChanged: (String? newValue) {
        setState(() {
          language.proficiencyController.text = newValue!; // Update value
        });
      },
      items: proficiencyLevels.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a proficiency level';
        }
        return null;
      },
    );
  }

  bool _validateLanguages(ResumeProvider resumeProvider) {
    bool allValid = true;
    for (var language in resumeProvider.getAllLanguages) {
      if (!language.isSaved) {
        allValid = false;
        break;
      }
    }
    return allValid;
  }

  bool _validateLanguageEntry(Language language) {
    if (language.languageNameController.text.isEmpty ||
        language.proficiencyController.text.isEmpty) {
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
