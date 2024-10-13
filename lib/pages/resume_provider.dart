import 'package:flutter/material.dart';

class WorkExperience {
  final int id;
  TextEditingController jobTitleController;
  TextEditingController companyController;
  TextEditingController startDateController;
  TextEditingController endDateController;
  TextEditingController descriptionController;
  bool isSaved;
  bool isExpanded;

  static int _idCounter = 0;

  WorkExperience({
    TextEditingController? jobTitleController,
    TextEditingController? companyController,
    TextEditingController? startDateController,
    TextEditingController? endDateController,
    TextEditingController? descriptionController,
    this.isSaved = false,
    bool? isExpanded,
    int? id,
  })  : id = id ?? _idCounter++,
        isExpanded = isExpanded ?? true,
        jobTitleController = jobTitleController ?? TextEditingController(),
        companyController = companyController ?? TextEditingController(),
        startDateController = startDateController ?? TextEditingController(),
        endDateController = endDateController ?? TextEditingController(),
        descriptionController =
            descriptionController ?? TextEditingController();

  // Getters for convenience
  String get jobTitle => jobTitleController.text;
  String get companyName => companyController.text;
  String get startDate => startDateController.text;
  String get endDate => endDateController.text;
  String get description => descriptionController.text;

  // Convert to Map for serialization purposes
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
      'isSaved': isSaved,
      'isExpanded': isExpanded,
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
  final int id;
  TextEditingController schoolNameController;
  TextEditingController degreeController;
  TextEditingController fieldOfStudyController;
  TextEditingController startYearController;
  TextEditingController endYearController;
  bool isSaved;
  bool isExpanded;

  static int _idCounter = 0;

  Education({
    TextEditingController? schoolNameController,
    TextEditingController? degreeController,
    TextEditingController? fieldOfStudyController,
    TextEditingController? startYearController,
    TextEditingController? endYearController,
    this.isSaved = false,
    bool? isExpanded,
    int? id,
  })  : id = id ?? _idCounter++,
        isExpanded = isExpanded ?? true,
        schoolNameController = schoolNameController ?? TextEditingController(),
        degreeController = degreeController ?? TextEditingController(),
        fieldOfStudyController =
            fieldOfStudyController ?? TextEditingController(),
        startYearController = startYearController ?? TextEditingController(),
        endYearController = endYearController ?? TextEditingController();

  // Getters for convenience
  String get schoolName => schoolNameController.text;
  String get degree => degreeController.text;
  String get fieldOfStudy => fieldOfStudyController.text;
  String get startYear => startYearController.text;
  String get endYear => endYearController.text;

  // Convert to Map for serialization purposes
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'schoolName': schoolName,
      'degree': degree,
      'fieldOfStudy': fieldOfStudy,
      'startYear': startYear,
      'endYear': endYear,
      'isSaved': isSaved,
      'isExpanded': isExpanded,
    };
  }

  // Dispose controllers to avoid memory leaks
  void dispose() {
    schoolNameController.dispose();
    degreeController.dispose();
    fieldOfStudyController.dispose();
    startYearController.dispose();
    endYearController.dispose();
  }
}

class Skill {
  final int id;
  TextEditingController skillController;
  TextEditingController proficiencyController;
  bool isSaved;
  bool isExpanded;

  static int _idCounter = 0;

  Skill({
    TextEditingController? skillController,
    TextEditingController? proficiencyController,
    this.isSaved = false,
    bool? isExpanded,
    int? id,
  })  : id = id ?? _idCounter++,
        isExpanded = isExpanded ?? true,
        skillController = skillController ?? TextEditingController(),
        proficiencyController =
            proficiencyController ?? TextEditingController(text: 'Beginner');

  // Getters for convenience
  String get skillName => skillController.text;
  String get proficiency => proficiencyController.text;

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'skill': skillName,
      'proficiency': proficiency,
      'isSaved': isSaved,
      'isExpanded': isExpanded,
    };
  }

  // Dispose controllers to avoid memory leaks
  void dispose() {
    skillController.dispose();
    proficiencyController.dispose();
  }
}

class Language {
  final int id;
  TextEditingController languageNameController;
  TextEditingController proficiencyController;
  bool isSaved;
  bool isExpanded;

  static int _idCounter = 0;

  Language({
    TextEditingController? languageNameController,
    TextEditingController? proficiencyController,
    this.isSaved = false,
    bool? isExpanded,
    int? id,
  })  : id = id ?? _idCounter++,
        isExpanded = isExpanded ?? true,
        languageNameController =
            languageNameController ?? TextEditingController(),
        proficiencyController =
            proficiencyController ?? TextEditingController(text: 'Beginner');

  // Getters for convenience
  String get languageName => languageNameController.text;
  String get proficiency => proficiencyController.text;

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'language': languageName,
      'proficiency': proficiency,
      'isSaved': isSaved,
      'isExpanded': isExpanded,
    };
  }

  // Dispose controllers to avoid memory leaks
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
      'workExperiences': _workExperiences.map((exp) => exp.toMap()).toList(),
      'education': _educationList.map((edu) => edu.toMap()).toList(),
      'skills': _skillsList.map((skill) => skill.toMap()).toList(),
      'languages': _languagesList.map((lang) => lang.toMap()).toList(),
    };
  }

  // Method to set resume data from a fetched map
  void setResumeData(Map<String, dynamic> resumeData) {
    clearAllData(); // Clear existing data before setting new data

    // Set personal info
    fullNameController.text = resumeData['fullName'] ?? '';
    emailController.text = resumeData['email'] ?? '';
    phoneController.text = resumeData['phone'] ?? '';
    linkedInController.text = resumeData['linkedIn'] ?? '';
    portfolioController.text = resumeData['portfolio'] ?? '';

    // Set work experiences
    for (var expData in resumeData['workExperiences'] ?? []) {
      _workExperiences.add(WorkExperience(
        jobTitleController: TextEditingController(text: expData['jobTitle']),
        companyController: TextEditingController(text: expData['companyName']),
        startDateController: TextEditingController(text: expData['startDate']),
        endDateController: TextEditingController(text: expData['endDate']),
        descriptionController:
            TextEditingController(text: expData['description']),
        isSaved: expData['isSaved'] ?? true,
        isExpanded: expData['isExpanded'] ?? false,
        id: expData['id'],
      ));
    }

    // Set education
    for (var eduData in resumeData['education'] ?? []) {
      _educationList.add(Education(
        schoolNameController:
            TextEditingController(text: eduData['schoolName']),
        degreeController: TextEditingController(text: eduData['degree']),
        fieldOfStudyController:
            TextEditingController(text: eduData['fieldOfStudy']),
        startYearController: TextEditingController(text: eduData['startYear']),
        endYearController: TextEditingController(text: eduData['endYear']),
        isSaved: eduData['isSaved'] ?? true,
        isExpanded: eduData['isExpanded'] ?? false,
        id: eduData['id'],
      ));
    }

    // Set skills
    for (var skillData in resumeData['skills'] ?? []) {
      _skillsList.add(Skill(
        skillController: TextEditingController(text: skillData['skill']),
        proficiencyController:
            TextEditingController(text: skillData['proficiency']),
        isSaved: skillData['isSaved'] ?? true,
        isExpanded: skillData['isExpanded'] ?? false,
        id: skillData['id'],
      ));
    }

    // Set languages
    for (var langData in resumeData['languages'] ?? []) {
      _languagesList.add(Language(
        languageNameController:
            TextEditingController(text: langData['language']),
        proficiencyController:
            TextEditingController(text: langData['proficiency']),
        isSaved: langData['isSaved'] ?? true,
        isExpanded: langData['isExpanded'] ?? false,
        id: langData['id'],
      ));
    }

    notifyListeners(); // Notify listeners to update UI
  }

  // Methods to manage work experiences
  void addExperience(WorkExperience experience) {
    _workExperiences.add(experience);
    notifyListeners();
  }

  void addExperienceAtTop(WorkExperience experience) {
    _workExperiences.insert(0, experience);
    notifyListeners();
  }

  void removeExperienceById(int id) {
    final index = _workExperiences.indexWhere((exp) => exp.id == id);
    if (index != -1) {
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

  void addEducationAtTop(Education education) {
    _educationList.insert(0, education);
    notifyListeners();
  }

  void removeEducationById(int id) {
    final index = _educationList.indexWhere((edu) => edu.id == id);
    if (index != -1) {
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

  void addSkillAtTop(Skill skill) {
    _skillsList.insert(0, skill);
    notifyListeners();
  }

  void removeSkillById(int id) {
    final index = _skillsList.indexWhere((skill) => skill.id == id);
    if (index != -1) {
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

  void addLanguageAtTop(Language language) {
    _languagesList.insert(0, language);
    notifyListeners();
  }

  void removeLanguageById(int id) {
    final index = _languagesList.indexWhere((lang) => lang.id == id);
    if (index != -1) {
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
