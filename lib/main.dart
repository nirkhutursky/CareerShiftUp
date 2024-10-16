import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Import firebase_options.dart for configuration
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_seeker/pages/resume_provider.dart';
import 'package:job_seeker/pages/resume_form_page.dart';
import 'package:job_seeker/pages/summary.dart';
import 'package:job_seeker/pages/personal_info_form_page.dart';
import 'package:job_seeker/pages/education_form_page.dart';
import 'package:job_seeker/pages/skills_form_page.dart';
import 'package:job_seeker/pages/languages_form_page.dart';
import 'package:job_seeker/pages/auth_screen.dart'; // Correctly import AuthScreen
import 'home_page.dart';
import 'package:job_seeker/pages/resume_tailoring_page.dart';
import 'package:job_seeker/pages/resume_generator_page.dart';
import 'package:job_seeker/pages/portfolio_builder_page.dart';
import 'package:job_seeker/pages/skill_based_resumes_page.dart';
import 'package:job_seeker/pages/application_tracker_page.dart';
import 'package:job_seeker/pages/market_trends_page.dart';
import 'package:job_seeker/pages/interview_prep_page.dart';
import 'package:job_seeker/pages/tasksPage.dart'; // Assuming this is the task page file name

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ); // Properly initialize Firebase with options
    runApp(const MyApp());
  } catch (e) {
    // Log any error that occurs during initialization
    print('Error initializing Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ResumeProvider()),
      ],
      child: MaterialApp(
        title: 'Career Shift Up',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthWrapper(),
        routes: {
          '/personalInfo': (context) => PersonalInfoFormPage(),
          '/educationForm': (context) => const EducationFormPage(),
          '/skillsForm': (context) => const SkillsFormPage(),
          '/languagesForm': (context) => const LanguagesFormPage(),
          '/resumeForm': (context) => const ResumeFormPage(),
          '/summaryPage': (context) => const Summary(),
          '/resumeTailoring': (context) => const ResumeTailoringPage(),
          '/resumeGenerator': (context) => const ResumeGeneratorPage(),
          '/portfolioBuilder': (context) => const PortfolioBuilderPage(),
          '/skillBasedResumes': (context) => const SkillBasedResumesPage(),
          '/applicationTracker': (context) => const ApplicationTrackerPage(),
          '/marketTrends': (context) => const MarketTrendsPage(),
          '/interviewPrep': (context) => const InterviewPrepPage(),
          '/tasks': (context) =>
              TasksPage(), // <-- Add this line for the task page
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          // User is signed in
          return const HomePage();
        } else {
          // User is not signed in
          return const AuthScreen();
        }
      },
    );
  }
}
