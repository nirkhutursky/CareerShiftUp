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

class Education {
  TextEditingController schoolNameController;
  TextEditingController degreeController;
  TextEditingController fieldOfStudyController;
  TextEditingController startYearController;
  TextEditingController endYearController;
  bool isSaved; // Add isSaved to track the save state of the education entry

  Education({
    required this.schoolNameController,
    required this.degreeController,
    required this.fieldOfStudyController,
    required this.startYearController,
    required this.endYearController,
    this.isSaved = false, // Default value is false
  });

  void dispose() {
    schoolNameController.dispose();
    degreeController.dispose();
    fieldOfStudyController.dispose();
    startYearController.dispose();
    endYearController.dispose();
  }
}

class Skill {
  TextEditingController skillController;
  TextEditingController proficiencyController;
  bool isSaved; // Add isSaved field to track if the skill has been saved

  Skill({
    required this.skillController,
    required this.proficiencyController,
    this.isSaved = false, // Default isSaved to false initially
  });

  void dispose() {
    skillController.dispose();
    proficiencyController.dispose();
  }
}

class Language {
  TextEditingController languageNameController;
  TextEditingController proficiencyController;
  bool isSaved; // Add this property to track whether the entry is saved

  Language({
    required this.languageNameController,
    required this.proficiencyController,
    this.isSaved = false, // Default value is false until saved
  });

  void dispose() {
    languageNameController.dispose();
    proficiencyController.dispose();
  }
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

  // Education
  List<Education> _educationList = [];

  // Skills
  List<Skill> _skillsList = [];

  // Languages
  List<Language> _languagesList = [];

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

  // Methods to manage education
  void addEducation(Education education) {
    _educationList.add(education);
    notifyListeners();
  }

  void removeEducation(int index) {
    if (index < _educationList.length) {
      _educationList[index].dispose();
      _educationList.removeAt(index);
      notifyListeners();
    }
  }

  List<Education> get getAllEducation => _educationList;

  // Methods to manage skills
  void addSkill(Skill skill) {
    _skillsList.add(skill);
    notifyListeners();
  }

  void removeSkill(int index) {
    if (index < _skillsList.length) {
      _skillsList[index].dispose();
      _skillsList.removeAt(index);
      notifyListeners();
    }
  }

  List<Skill> get getAllSkills => _skillsList;

  // Methods to manage languages
  void addLanguage(Language language) {
    _languagesList.add(language);
    notifyListeners();
  }

  void removeLanguage(int index) {
    if (index < _languagesList.length) {
      _languagesList[index].dispose();
      _languagesList.removeAt(index);
      notifyListeners();
    }
  }

  List<Language> get getAllLanguages => _languagesList;

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

    for (var education in _educationList) {
      education.dispose();
    }

    for (var skill in _skillsList) {
      skill.dispose();
    }

    for (var language in _languagesList) {
      language.dispose();
    }
  }
}
