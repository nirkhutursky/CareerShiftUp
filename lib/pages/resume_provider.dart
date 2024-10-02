// resume_provider.dart

import 'package:flutter/material.dart';

class WorkExperience {
  TextEditingController jobTitleController;
  TextEditingController companyController;
  TextEditingController startDateController;
  TextEditingController endDateController;
  TextEditingController descriptionController;
  bool isExpanded;
  bool isSaved;

  WorkExperience({
    required this.jobTitleController,
    required this.companyController,
    required this.startDateController,
    required this.endDateController,
    required this.descriptionController,
    this.isExpanded = true,
    this.isSaved = false,
  });

  void dispose() {
    jobTitleController.dispose();
    companyController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    descriptionController.dispose();
  }

  // Getters for convenience
  String get jobTitle => jobTitleController.text;
  String get companyName => companyController.text;
  String get startDate => startDateController.text;
  String get endDate => endDateController.text;
  String get description => descriptionController.text;
}

class ResumeProvider with ChangeNotifier {
  // Personal Info
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController linkedInController = TextEditingController();
  TextEditingController portfolioController = TextEditingController();

  // Work Experiences
  List<WorkExperience> _workExperiences = [];

  // Other Sections (e.g., Education, Skills)
  // Add more fields here as needed

  // Methods to manage work experiences
  void addExperience(WorkExperience experience) {
    _workExperiences.add(experience);
    notifyListeners();
  }

  void removeExperience(int index) {
    if (index < _workExperiences.length) {
      _workExperiences[index].dispose();
      _workExperiences.removeAt(index);
      notifyListeners();
    }
  }

  List<WorkExperience> get getAllExperiences => _workExperiences;

  // Dispose method to clean up controllers
  void disposeControllers() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    linkedInController.dispose();
    portfolioController.dispose();

    for (var experience in _workExperiences) {
      experience.dispose();
    }
  }
}
