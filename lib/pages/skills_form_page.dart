import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'resume_provider.dart'; // Ensure this import is correct
import 'shared_layout.dart'; // Import the shared layout

class SkillsFormPage extends StatefulWidget {
  const SkillsFormPage({Key? key}) : super(key: key);

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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resumeProvider = Provider.of<ResumeProvider>(context);

    return SharedLayout(
      // Use SharedLayout to wrap Scaffold
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
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () {
                  if (_validateInputs(resumeProvider)) {
                    Navigator.pushNamed(
                        context, '/languagesForm'); // Navigate to LanguagesForm
                  } else {
                    _showErrorDialog(context,
                        "Please fill in all required fields or delete unnecessary skills.");
                  }
                },
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
                  // Skill Name (Flexible)
                  Expanded(
                    child: _buildTextFormField(
                      label: 'Skill Name (Required)',
                      icon: Icons.label,
                      controller: skill.skillController,
                      isMandatory: true,
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Proficiency Dropdown (Fixed Width)
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
                    } else {
                      _showErrorDialog(
                          context, 'Please fill all required fields!');
                    }
                  },
                  child: const Text('Save Skill',
                      style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
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
    // Proficiency levels list
    const List<String> proficiencyLevels = [
      'Beginner',
      'Intermediate',
      'Advanced',
      'Expert'
    ];

    // Set the initial value of the dropdown to the first option ('Beginner')
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        // Initialize the dropdown with the first value if no value is set
        value: skill.proficiencyController.text.isNotEmpty
            ? skill.proficiencyController.text
            : proficiencyLevels[0], // Default to 'Beginner'
        decoration: InputDecoration(
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
        isDense: true, // Makes the dropdown appear more compact
        onChanged: (String? newValue) {
          setState(() {
            skill.proficiencyController.text = newValue!; // Update value
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
          setState(() {}); // Update UI
        },
      ),
    );
  }

  bool _validateInputs(ResumeProvider resumeProvider) {
    bool allValid = true;
    for (var skill in resumeProvider.getAllSkills) {
      if (!skill.isSaved) {
        allValid = false;
        break;
      }
    }
    return allValid;
  }

  bool _validateSkillInputs(Skill skill, BuildContext context) {
    if (skill.skillController.text.isEmpty ||
        skill.proficiencyController.text.isEmpty) {
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
