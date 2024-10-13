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

  // Getters for UI compatibility
  String get jobTitle => jobTitleController.text;
  String get companyName => companyController.text;
  String get startDate => startDateController.text;
  String get endDate => endDateController.text;
  String get description => descriptionController.text;

  // Convert to Map for serialization purposes
  Map<String, String> toMap() {
    return {
      'jobTitle': jobTitleController.text,
      'companyName': companyController.text,
      'startDate': startDateController.text,
      'endDate': endDateController.text,
      'description': descriptionController.text,
    };
  }

  // Dispose controllers to avoid memory leaks
  void dispose() {
    jobTitleController.dispose();
    companyController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    descriptionController.dispose();
  }
}

class Education {
  TextEditingController schoolNameController;
  TextEditingController degreeController;
  TextEditingController fieldOfStudyController;
  TextEditingController startYearController;
  TextEditingController endYearController;
  bool isSaved;

  Education({
    required this.schoolNameController,
    required this.degreeController,
    required this.fieldOfStudyController,
    required this.startYearController,
    required this.endYearController,
    this.isSaved = false,
  });

  void dispose() {
    schoolNameController.dispose();
    degreeController.dispose();
    fieldOfStudyController.dispose();
    startYearController.dispose();
    endYearController.dispose();
  }

  // Convert to Map
  Map<String, String> toMap() {
    return {
      'schoolName': schoolNameController.text,
      'degree': degreeController.text,
      'fieldOfStudy': fieldOfStudyController.text,
      'startYear': startYearController.text,
      'endYear': endYearController.text,
    };
  }
}

class Skill {
  TextEditingController skillController;
  TextEditingController proficiencyController;
  bool isSaved;

  Skill({
    required this.skillController,
    required this.proficiencyController,
    this.isSaved = false,
  }) {
    proficiencyController.text = 'Beginner';
  }

  void dispose() {
    skillController.dispose();
    proficiencyController.dispose();
  }

  // Convert to Map
  Map<String, String> toMap() {
    return {
      'skill': skillController.text,
      'proficiency': proficiencyController.text,
    };
  }
}

class Language {
  TextEditingController languageNameController;
  TextEditingController proficiencyController;
  bool isSaved;

  Language({
    required this.languageNameController,
    required this.proficiencyController,
    this.isSaved = false,
  }) {
    proficiencyController.text = 'Beginner';
  }

  void dispose() {
    languageNameController.dispose();
    proficiencyController.dispose();
  }

  // Convert to Map
  Map<String, String> toMap() {
    return {
      'language': languageNameController.text,
      'proficiency': proficiencyController.text,
    };
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
  final List<WorkExperience> _workExperiences = [];

  // Education
  final List<Education> _educationList = [];

  // Skills
  final List<Skill> _skillsList = [];

  // Languages
  final List<Language> _languagesList = [];

  // Method to convert all resume data into a map
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullNameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'linkedIn': linkedInController.text,
      'portfolio': portfolioController.text,
      'workExperiences':
          _workExperiences.map((experience) => experience.toMap()).toList(),
      'education':
          _educationList.map((education) => education.toMap()).toList(),
      'skills': _skillsList.map((skill) => skill.toMap()).toList(),
      'languages': _languagesList.map((language) => language.toMap()).toList(),
    };
  }

  // Methods to set resume data from a fetched map
  void setResumeData(Map<String, dynamic> resumeData) {
    clearAllData(); // Clear existing data before setting new data

    // Set personal info
    fullNameController.text = resumeData['fullName'] ?? '';
    emailController.text = resumeData['email'] ?? '';
    phoneController.text = resumeData['phone'] ?? '';
    linkedInController.text = resumeData['linkedIn'] ?? '';
    portfolioController.text = resumeData['portfolio'] ?? '';

    // Set work experiences
    for (var experienceData in resumeData['workExperiences'] ?? []) {
      _workExperiences.add(WorkExperience(
        jobTitleController:
            TextEditingController(text: experienceData['jobTitle']),
        companyController:
            TextEditingController(text: experienceData['companyName']),
        startDateController:
            TextEditingController(text: experienceData['startDate']),
        endDateController:
            TextEditingController(text: experienceData['endDate']),
        descriptionController:
            TextEditingController(text: experienceData['description']),
      ));
    }

    // Set education
    for (var educationData in resumeData['education'] ?? []) {
      _educationList.add(Education(
        schoolNameController:
            TextEditingController(text: educationData['schoolName']),
        degreeController: TextEditingController(text: educationData['degree']),
        fieldOfStudyController:
            TextEditingController(text: educationData['fieldOfStudy']),
        startYearController:
            TextEditingController(text: educationData['startYear']),
        endYearController:
            TextEditingController(text: educationData['endYear']),
      ));
    }

    // Set skills
    for (var skillData in resumeData['skills'] ?? []) {
      _skillsList.add(Skill(
        skillController: TextEditingController(text: skillData['skill']),
        proficiencyController:
            TextEditingController(text: skillData['proficiency']),
      ));
    }

    // Set languages
    for (var languageData in resumeData['languages'] ?? []) {
      _languagesList.add(Language(
        languageNameController:
            TextEditingController(text: languageData['language']),
        proficiencyController:
            TextEditingController(text: languageData['proficiency']),
      ));
    }

    notifyListeners(); // Notify listeners to update UI
  }

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

  // Method to clear all data
  void clearAllData() {
    fullNameController.clear();
    emailController.clear();
    phoneController.clear();
    linkedInController.clear();
    portfolioController.clear();

    for (var experience in _workExperiences) {
      experience.dispose();
    }
    _workExperiences.clear();

    for (var education in _educationList) {
      education.dispose();
    }
    _educationList.clear();

    for (var skill in _skillsList) {
      skill.dispose();
    }
    _skillsList.clear();

    for (var language in _languagesList) {
      language.dispose();
    }
    _languagesList.clear();

    notifyListeners();
  }

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
