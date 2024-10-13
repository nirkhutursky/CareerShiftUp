import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'resume_provider.dart'; // Ensure this import is correct
import 'shared_layout.dart'; // Import the shared layout

class LanguagesFormPage extends StatefulWidget {
  const LanguagesFormPage({Key? key}) : super(key: key);

  @override
  _LanguagesFormPageState createState() => _LanguagesFormPageState();
}

class _LanguagesFormPageState extends State<LanguagesFormPage> {
  final _formKey = GlobalKey<FormState>();

  bool _allLanguagesSaved(ResumeProvider resumeProvider) {
    return resumeProvider.getAllLanguages.every((language) => language.isSaved);
  }

  @override
  Widget build(BuildContext context) {
    final resumeProvider = Provider.of<ResumeProvider>(context);

    return SharedLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Languages Information'),
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
                      onPressed: _allLanguagesSaved(resumeProvider)
                          ? () {
                              // Add new language at the top
                              resumeProvider.addLanguageAtTop(
                                Language(
                                  languageNameController:
                                      TextEditingController(),
                                  proficiencyController:
                                      TextEditingController(text: 'Beginner'),
                                  isExpanded:
                                      true, // Ensure new language is expanded
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _allLanguagesSaved(resumeProvider)
                            ? Colors.blueAccent
                            : Colors.grey,
                      ),
                      child: const Text('Add Language',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _allLanguagesSaved(resumeProvider)
                          ? () {
                              Navigator.pushNamed(context, '/resumeForm');
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _allLanguagesSaved(resumeProvider)
                            ? Colors.greenAccent[400]
                            : Colors.grey,
                      ),
                      child: const Text('Submit Languages',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildLanguagesList(resumeProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguagesList(ResumeProvider resumeProvider) {
    return ListView.builder(
      itemCount: resumeProvider.getAllLanguages.length,
      itemBuilder: (context, index) {
        final language = resumeProvider.getAllLanguages[index];
        return LanguagePanel(
          key: ValueKey(language.id),
          language: language,
          formKey: _formKey,
        );
      },
    );
  }
}

class LanguagePanel extends StatefulWidget {
  final Language language;
  final GlobalKey<FormState> formKey;

  const LanguagePanel({
    Key? key,
    required this.language,
    required this.formKey,
  }) : super(key: key);

  @override
  _LanguagePanelState createState() => _LanguagePanelState();
}

class _LanguagePanelState extends State<LanguagePanel> {
  @override
  Widget build(BuildContext context) {
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);

    return Card(
      key: ValueKey(widget.language.id),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.language.languageNameController.text.isEmpty
                  ? 'Language'
                  : widget.language.languageNameController.text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: Icon(widget.language.isExpanded
                  ? Icons.expand_less
                  : Icons.expand_more),
              onPressed: () {
                setState(() {
                  widget.language.isExpanded = !widget.language.isExpanded;
                });
              },
            ),
          ),
          if (widget.language.isExpanded)
            _buildLanguageForm(widget.language, resumeProvider),
        ],
      ),
    );
  }

  Widget _buildLanguageForm(Language language, ResumeProvider resumeProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildTextField(
                  label: 'Language Name (Required)',
                  controller: language.languageNameController,
                  isMandatory: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: _buildProficiencyDropdown(language),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent[400],
            ),
            onPressed: () {
              if (_validateLanguageInputs(language)) {
                setState(() {
                  language.isSaved = true;
                  language.isExpanded = false;
                });
                resumeProvider.notifyListeners(); // Notify parent widget
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Language saved successfully!')),
                );
              } else {
                _showErrorDialog(context, 'Please fill all required fields!');
              }
            },
            child: const Text('Save Language',
                style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent[200],
            ),
            onPressed: () {
              resumeProvider.removeLanguageById(language.id);
            },
            child: const Text('Remove Language',
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

  Widget _buildProficiencyDropdown(Language language) {
    const List<String> proficiencyLevels = [
      'Beginner',
      'Elementary',
      'Intermediate',
      'Upper Intermediate',
      'Advanced',
      'Proficient'
    ];

    return DropdownButtonFormField<String>(
      value: language.proficiencyController.text.isNotEmpty
          ? language.proficiencyController.text
          : 'Beginner',
      items: proficiencyLevels.map((level) {
        return DropdownMenuItem<String>(
          value: level,
          child: Text(level),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Proficiency',
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        setState(() {
          language.proficiencyController.text = value ?? 'Beginner';
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Proficiency is required';
        }
        return null;
      },
    );
  }

  bool _validateLanguageInputs(Language language) {
    final RegExp allowedCharsRegex = RegExp(r'^[a-zA-Z\s]+$');

    if (!allowedCharsRegex.hasMatch(language.languageNameController.text)) {
      _showErrorDialog(context, 'Language name contains illegal characters.');
      return false;
    }

    if (language.languageNameController.text.isEmpty) {
      _showErrorDialog(context, 'Language name is required.');
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

  String? _validateField(String? value, String label, bool isMandatory) {
    if (isMandatory && (value == null || value.trim().isEmpty)) {
      return '$label is required';
    }

    if (value != null && !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return '$label contains invalid characters';
    }

    return null;
  }
}
