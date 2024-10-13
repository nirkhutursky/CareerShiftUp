import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'resume_provider.dart'; // Ensure this import is correct
import 'shared_layout.dart'; // Import the shared layout

class LanguagesFormPage extends StatefulWidget {
  const LanguagesFormPage({super.key});

  @override
  _LanguagesFormPageState createState() => _LanguagesFormPageState();
}

class _LanguagesFormPageState extends State<LanguagesFormPage> {
  List<bool> _isExpandedList = [];

  @override
  void initState() {
    super.initState();
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);
    _syncExpansionState(resumeProvider);
  }

  // Sync _isExpandedList with the number of languages in the provider
  void _syncExpansionState(ResumeProvider resumeProvider) {
    setState(() {
      _isExpandedList = List<bool>.filled(
        resumeProvider.getAllLanguages.length,
        true,
        growable: true,
      );
    });
  }

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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              _buildLanguagesPanelList(resumeProvider),
              _buildAddLanguageButton(resumeProvider),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _allLanguagesSaved(resumeProvider)
                      ? Colors.blueAccent
                      : Colors.grey, // Set the button color
                ),
                onPressed: _allLanguagesSaved(resumeProvider)
                    ? () {
                        Navigator.pushNamed(context,
                            '/resumeForm'); // Navigate to the next form
                      }
                    : null, // Disable button if not all entries are saved
                child: const Text('Submit Languages',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguagesPanelList(ResumeProvider resumeProvider) {
    // Sync _isExpandedList if the number of languages changes
    if (_isExpandedList.length != resumeProvider.getAllLanguages.length) {
      _syncExpansionState(resumeProvider);
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
              title: Row(
                children: [
                  Expanded(
                    child: _buildTextFormField(
                      label: 'Language Name (Required)',
                      icon: Icons.language,
                      controller: language.languageNameController,
                      isMandatory: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: _buildProficiencyDropdown(language),
                  ),
                ],
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent[400],
                  ),
                  onPressed: () {
                    if (_validateLanguageInputs(language, context)) {
                      setState(() {
                        language.isSaved = true; // Mark as saved
                        _isExpandedList[index] = false; // Collapse the panel
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Language saved successfully!')),
                      );
                    }
                  },
                  child: const Text('Save Language',
                      style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      resumeProvider.removeLanguage(index);
                      _isExpandedList.removeAt(index);
                    });
                  },
                  child: const Text('Remove Language'),
                ),
              ],
            ),
          ),
          isExpanded: _isExpandedList[index],
        );
      }),
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: language.proficiencyController.text.isNotEmpty
            ? language.proficiencyController.text
            : proficiencyLevels[0], // Default to 'Beginner'
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.blue[50],
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.blueAccent),
          ),
        ),
        isDense: true,
        items: proficiencyLevels.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            language.proficiencyController.text = newValue!;
          });
        },
      ),
    );
  }

  Widget _buildAddLanguageButton(ResumeProvider resumeProvider) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.greenAccent[400],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {
        resumeProvider.addLanguage(
          Language(
            languageNameController: TextEditingController(),
            proficiencyController: TextEditingController(),
          ),
        );

        setState(() {
          _syncExpansionState(resumeProvider);
        });
      },
      child: const Text('Add Language', style: TextStyle(color: Colors.black)),
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
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  bool _validateLanguageInputs(Language language, BuildContext context) {
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
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
