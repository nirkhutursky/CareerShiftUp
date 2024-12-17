# Resume Builder App

**A Flutter-based application that allows users to create, manage, and export their resumes interactively.**

This project is a feature-rich resume-building tool where users can input their personal information, work experiences, education details, languages, and skills to build customized resumes.

---

## Table of Contents
1. [Features](#features)
2. [Technologies Used](#technologies-used)
3. [Setup Instructions](#setup-instructions)
4. [Project Structure](#project-structure)
5. [Key Flutter Concepts Used](#key-flutter-concepts-used)
6. [Screens Overview](#screens-overview)
7. [Next Steps](#next-steps)
8. [How to Contribute](#how-to-contribute)
9. [License](#license)

---

## Features

- **Interactive Forms**: Users can add, edit, and delete sections such as:
  - Personal Information (Name, Email, Phone, LinkedIn, Portfolio)
  - Work Experience (Job Title, Company Name, Start/End Year, Role Description)
  - Education Details
  - Skills
  - Languages with Proficiency Levels

- **Form Validation**:
  - Ensures fields contain valid input (e.g., alphabet-only for job titles and company names).
  - Displays meaningful error messages.

- **Dynamic UI**:
  - Add or remove sections dynamically (e.g., add multiple work experiences or languages).
  - Expandable and collapsible panels for easy navigation.

- **State Management**:
  - Uses the **Provider** package to manage form states efficiently across widgets.

- **Future-Ready**:
  - Ready for backend integration to persist resume data.
  - Built to export resumes as PDFs in future updates.

---

## Technologies Used

- **Framework**: Flutter (Dart)
- **State Management**: Provider
- **UI Components**: Material Design Widgets
- **Backend**: JS, next.js
- **Tools**:
  - Android Studio / Visual Studio Code
  - Dart DevTools

---

## Setup Instructions

### Prerequisites

- Install Flutter SDK: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
- Ensure you have Android Studio or VS Code installed with Flutter and Dart plugins.

### Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/resume-builder-flutter.git
   cd resume-builder-flutter
   ```

2. **Get Dependencies**
   Run the following command to fetch required packages:
   ```bash
   flutter pub get
   ```

3. **Run the Project**
   - Connect a device/emulator.
   - Run the app:
     ```bash
     flutter run
     ```

4. **Test the Project** (Optional):
   ```bash
   flutter test
   ```

---
## Key Flutter Concepts Used

### 1. **State Management with Provider**
   - The `Provider` package is used to manage global states like work experiences, languages, and user inputs.
   - All data operations (add, remove, validate) are handled through the `resume_provider.dart`.

### 2. **Dynamic UI with `setState`**
   - **Dynamic Panels**: The UI updates dynamically when users add or remove fields (e.g., work experiences or languages).
   - **`setState`** ensures changes to the UI reflect instantly within the stateful widgets.

### 3. **Form Validation**
   - Custom validation methods ensure inputs are correct (e.g., alphabet-only restrictions).
   - Displays specific error messages and restricts submission until all fields are valid.

### 4. **Reusable Widgets**
   - Components like text fields, dropdown menus, and buttons are modular and reusable.

---

## Screens Overview

### 1. **Personal Information Form**
   - Input fields for:
     - Full Name
     - Email Address
     - Phone Number
     - LinkedIn Profile
     - Portfolio Website

### 2. **Languages Form**
   - Add languages with dropdowns to select proficiency levels:
     - Beginner, Elementary, Intermediate, Advanced, etc.
   - Supports dynamic addition and deletion of languages.

### 3. **Work Experience Form**
   - Input fields for:
     - Job Title
     - Company Name
     - Start Year / End Year (with Year Picker)
     - Role Description
   - Supports multiple work experiences with dynamic panels.



---

## Next Steps

Here’s what can be done to further improve the project:

1. **Back-End Integration**
   - Connect with Firebase Firestore or a REST API to persist user data.

2. **PDF Resume Generation**
   - Use libraries like `flutter_pdf` or `pdf` to generate downloadable PDF resumes.

3. **User Authentication**
   - Add Google/Facebook login to allow users to save and retrieve their resumes.

4. **Resume Templates**
   - Allow users to choose different styles or templates for their resumes.

5. **Advanced Features**
   - AI-powered suggestions for job descriptions.
   - Resume tailoring based on job descriptions.

6. **Testing**
   - Add unit tests and widget tests for better code reliability.

---

## How to Contribute

We welcome contributions! Follow these steps:

1. **Fork the Repository**
2. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make Your Changes**
4. **Commit Your Changes**
   ```bash
   git commit -m "Add feature: your feature name"
   ```
5. **Push Your Changes**
   ```bash
   git push origin feature/your-feature-name
   ```
6. **Create a Pull Request**

---

## License

This project is licensed under the No License.

---

## Acknowledgements

- Flutter Documentation: [flutter.dev](https://flutter.dev/)
- Provider Package: [pub.dev/packages/provider](https://pub.dev/packages/provider)
