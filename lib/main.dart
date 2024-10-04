import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:job_seeker/pages/resume_provider.dart';
import 'package:job_seeker/pages/resume_form_page.dart';
import 'package:job_seeker/pages/summary.dart';
import 'package:job_seeker/pages/personal_info_form_page.dart'; // Add PersonalInfoFormPage
import 'package:job_seeker/pages/education_form_page.dart'; // Add EducationFormPage
import 'package:job_seeker/pages/skills_form_page.dart'; // Add SkillsFormPage
import 'package:job_seeker/pages/languages_form_page.dart'; // Add LanguagesFormPage
import 'home_page.dart'; // Import the new home page

import 'package:job_seeker/pages/resume_tailoring_page.dart';
import 'package:job_seeker/pages/resume_generator_page.dart';
import 'package:job_seeker/pages/portfolio_builder_page.dart';
import 'package:job_seeker/pages/skill_based_resumes_page.dart';
import 'package:job_seeker/pages/application_tracker_page.dart';
import 'package:job_seeker/pages/market_trends_page.dart';
import 'package:job_seeker/pages/interview_prep_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ResumeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Career Shift Up',
      initialRoute: '/', // Start from Personal Info
      routes: {
        '/': (context) => HomePage(),
        '/personalInfo': (context) => PersonalInfoFormPage(),
        '/educationForm': (context) =>
            const EducationFormPage(), // Education form
        '/skillsForm': (context) => const SkillsFormPage(), // Skills form
        '/languagesForm': (context) =>
            const LanguagesFormPage(), // Languages form
        '/resumeForm': (context) => const ResumeFormPage(),
        '/nextPage': (context) =>
            const Summary(), // Final page to show all experiences
        // Other routes for additional features
        '/resumeTailoring': (context) => const ResumeTailoringPage(),
        '/resumeGenerator': (context) => const ResumeGeneratorPage(),
        '/portfolioBuilder': (context) => const PortfolioBuilderPage(),
        '/skillBasedResumes': (context) => const SkillBasedResumesPage(),
        '/applicationTracker': (context) => const ApplicationTrackerPage(),
        '/marketTrends': (context) => const MarketTrendsPage(),
        '/interviewPrep': (context) => const InterviewPrepPage(),
      },
    );
  }
}
