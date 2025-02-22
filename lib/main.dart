import 'package:flutter/material.dart';
import 'package:free_mentor/providers/session_provider.dart';
import 'package:free_mentor/screens/admin_session_screen.dart';
import 'package:free_mentor/screens/promote_mentor_screen.dart';
import 'package:free_mentor/screens/session_history_screen.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/mentor_provider.dart';
import 'services/db_helper.dart'; // ✅ Added this import
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/mentor_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ Debugging: Log mentors at app start
  await DBHelper.getAllMentors().then((mentors) {
    print("✅ Mentors in database: ${mentors.length}");
    for (var mentor in mentors) {
      print("Mentor: ${mentor.name} - Expertise: ${mentor.expertise}");
    }
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MentorProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Free Mentors",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
      routes: {
         '/login': (context) => LoginScreen(), // ✅ Add this line
        '/signup': (context) => SignupScreen(),
        '/mentors': (context) => MentorListScreen(),
        '/promote': (context) => PromoteMentorScreen(),
        '/session_history': (context) => SessionHistoryScreen(), 
         '/admin_sessions': (context) => AdminSessionScreen(), 
      },
    );
  }
}
