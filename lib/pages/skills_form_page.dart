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
  final _formKey = GlobalKey<FormState>();

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
                      onPressed: _allSkillsSaved(resumeProvider)
                          ? () {
                              // Add new skill at the top
                              resumeProvider.addSkillAtTop(
                                Skill(
                                  skillController: TextEditingController(),
                                  proficiencyController:
                                      TextEditingController(text: 'Beginner'),
                                  isExpanded:
                                      true, // Ensure new skill is expanded
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _allSkillsSaved(resumeProvider)
                            ? Colors.blueAccent[400]
                            : Colors.grey,
                      ),
                      child: const Text('Add Skill',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _allSkillsSaved(resumeProvider)
                          ? () {
                              Navigator.pushNamed(context, '/languagesForm');
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _allSkillsSaved(resumeProvider)
                            ? Colors.greenAccent[400]
                            : Colors.grey,
                      ),
                      child: const Text('Submit Skills',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildSkillsList(resumeProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsList(ResumeProvider resumeProvider) {
    return ListView.builder(
      itemCount: resumeProvider.getAllSkills.length,
      itemBuilder: (context, index) {
        final skill = resumeProvider.getAllSkills[index];
        return SkillPanel(
          key: ValueKey(skill.id),
          skill: skill,
          formKey: _formKey,
        );
      },
    );
  }
}

class SkillPanel extends StatefulWidget {
  final Skill skill;
  final GlobalKey<FormState> formKey;

  const SkillPanel({
    super.key,
    required this.skill,
    required this.formKey,
  });

  @override
  _SkillPanelState createState() => _SkillPanelState();
}

class _SkillPanelState extends State<SkillPanel> {
  @override
  Widget build(BuildContext context) {
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);

    return Card(
      key: ValueKey(widget.skill.id),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.skill.skillController.text.isEmpty
                  ? 'Skill'
                  : widget.skill.skillController.text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: Icon(widget.skill.isExpanded
                  ? Icons.expand_less
                  : Icons.expand_more),
              onPressed: () {
                setState(() {
                  widget.skill.isExpanded = !widget.skill.isExpanded;
                });
              },
            ),
          ),
          if (widget.skill.isExpanded)
            _buildSkillForm(widget.skill, resumeProvider),
        ],
      ),
    );
  }

  Widget _buildSkillForm(Skill skill, ResumeProvider resumeProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Skill Name (Required)',
                  controller: skill.skillController,
                  isMandatory: true,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 150,
                child: _buildProficiencyDropdown(skill),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent[400],
            ),
            onPressed: () {
              if (_validateSkillInputs(skill)) {
                setState(() {
                  skill.isSaved = true;
                  skill.isExpanded = false;
                });
                resumeProvider.notifyListeners(); // Notify parent widget
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Skill saved successfully!')),
                );
              } else {
                _showErrorDialog(context, 'Please fill all required fields!');
              }
            },
            child:
                const Text('Save Skill', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent[200],
            ),
            onPressed: () {
              resumeProvider.removeSkillById(skill.id);
            },
            child: const Text('Remove Skill',
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

  Widget _buildProficiencyDropdown(Skill skill) {
    const List<String> proficiencyLevels = [
      'Beginner',
      'Intermediate',
      'Advanced',
      'Expert'
    ];

    return DropdownButtonFormField<String>(
      value: skill.proficiencyController.text.isNotEmpty
          ? skill.proficiencyController.text
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
          skill.proficiencyController.text = value ?? 'Beginner';
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

  bool _validateSkillInputs(Skill skill) {
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

    if (value != null && !RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
      return '$label contains invalid characters';
    }

    return null;
  }
}
