import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'resume_provider.dart';
import 'shared_layout.dart'; // Import the shared layout

class SkillsFormPage extends StatefulWidget {
  const SkillsFormPage({super.key});

  @override
  _SkillsFormPageState createState() => _SkillsFormPageState();
}

class _SkillsFormPageState extends State<SkillsFormPage> {
  List<bool> _isExpandedList = [];

  @override
  void initState() {
    super.initState();
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);
    _isExpandedList = List<bool>.filled(
      resumeProvider.getAllSkills.length,
      true,
      growable: true,
    );
  }

  bool _allSkillsSaved(ResumeProvider resumeProvider) {
    return resumeProvider.getAllSkills.every((skill) => skill.isSaved);
  }

  @override
  Widget build(BuildContext context) {
    final resumeProvider = Provider.of<ResumeProvider>(context);

    return SharedLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Skills Information'),
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
              _buildSkillsPanelList(resumeProvider),
              _buildAddSkillButton(resumeProvider),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _allSkillsSaved(resumeProvider)
                      ? Colors.blueAccent
                      : Colors.grey, // Set the button color
                ),
                onPressed: _allSkillsSaved(resumeProvider)
                    ? () {
                        Navigator.pushNamed(context,
                            '/languagesForm'); // Navigate to LanguagesForm
                      }
                    : null, // Disable button if not all entries are saved
                child: const Text('Submit Skills',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsPanelList(ResumeProvider resumeProvider) {
    if (_isExpandedList.length < resumeProvider.getAllSkills.length) {
      int difference =
          resumeProvider.getAllSkills.length - _isExpandedList.length;
      _isExpandedList.addAll(
          List<bool>.filled(difference, true)); // Expand new panels by default
    } else if (_isExpandedList.length > resumeProvider.getAllSkills.length) {
      _isExpandedList =
          _isExpandedList.sublist(0, resumeProvider.getAllSkills.length);
    }

    return ExpansionPanelList(
      elevation: 1,
      expandedHeaderPadding: const EdgeInsets.all(8),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isExpandedList[index] = !_isExpandedList[index];
        });
      },
      children: List.generate(resumeProvider.getAllSkills.length, (int index) {
        final skill = resumeProvider.getAllSkills[index];
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: _buildTextFormField(
                      label: 'Skill Name (Required)',
                      icon: Icons.label,
                      controller: skill.skillController,
                      isMandatory: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 150, // Fixed width for the dropdown
                    child: _buildProficiencyDropdown(skill),
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
                    if (_validateSkillInputs(skill, context)) {
                      setState(() {
                        skill.isSaved = true; // Mark as saved
                        _isExpandedList[index] = false; // Collapse the panel
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Skill saved successfully!')),
                      );
                    }
                  },
                  child: const Text('Save Skill',
                      style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      resumeProvider.removeSkill(index);
                      _isExpandedList.removeAt(index);
                    });
                  },
                  child: const Text('Remove Skill'),
                ),
              ],
            ),
          ),
          isExpanded: _isExpandedList[index],
        );
      }),
    );
  }

  Widget _buildProficiencyDropdown(Skill skill) {
    const List<String> proficiencyLevels = [
      'Beginner',
      'Intermediate',
      'Advanced',
      'Expert'
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: skill.proficiencyController.text.isNotEmpty
            ? skill.proficiencyController.text
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
            skill.proficiencyController.text = newValue!;
          });
        },
      ),
    );
  }

  Widget _buildAddSkillButton(ResumeProvider resumeProvider) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.greenAccent[400],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {
        setState(() {
          resumeProvider.addSkill(
            Skill(
              skillController: TextEditingController(),
              proficiencyController: TextEditingController(),
            ),
          );
          _isExpandedList.add(true); // Expand the new panel by default
        });
      },
      child: const Text('Add Skill', style: TextStyle(color: Colors.black)),
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

  bool _validateSkillInputs(Skill skill, BuildContext context) {
    final RegExp allowedCharsRegex = RegExp(r'^[a-zA-Z0-9\s]+$');

    if (!allowedCharsRegex.hasMatch(skill.skillController.text)) {
      _showErrorDialog(context, 'Skill name contains illegal characters.');
      return false;
    }

    if (skill.skillController.text.isEmpty) {
      _showErrorDialog(context, 'Skill name is required.');
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
