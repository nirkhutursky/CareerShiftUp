import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:job_seeker/pages/resume_provider.dart';
import 'package:job_seeker/pages/resume_form_page.dart';
import 'package:job_seeker/pages/next_page.dart';
import 'package:job_seeker/pages/personal_info_form_page.dart'; // Add PersonalInfoFormPage
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
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/personalInfo': (context) => const PersonalInfoFormPage(),
        '/resumeForm': (context) => const ResumeFormPage(),
        '/nextPage': (context) =>
            const NextPage(), // Final page to show all experiences
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
