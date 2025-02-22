// /*
// SERGE MUNEZA (20248/2022)
//  */


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/mentor_provider.dart';
import 'providers/session_provider.dart';
import 'services/db_helper.dart';
import 'screens/welcome_screen.dart'; // ✅ Import WelcomeScreen
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/mentor_list_screen.dart';
import 'screens/promote_mentor_screen.dart';
import 'screens/session_history_screen.dart';
import 'screens/admin_session_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeApp();
  runApp(MyApp());
}

// ✅ Initialize Database & Fetch Mentors Before App Starts
Future<void> _initializeApp() async {
  await DBHelper.getAllMentors().then((mentors) {
    debugPrint("✅ Mentors in database: ${mentors.length}");
    for (var mentor in mentors) {
      debugPrint("Mentor: ${mentor.name} - Expertise: ${mentor.expertise}");
    }
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MentorProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Free Mentors",
        theme: ThemeData(primarySwatch: Colors.blue),
        home: FutureBuilder(
          future: _initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingScreen(); // ✅ Show loading screen before initialization
            }
            return WelcomeScreen(); // ✅ Now WelcomeScreen is the first page
          },
        ),
        routes: {
          '/welcome': (context) => WelcomeScreen(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/mentors': (context) => MentorListScreen(),
          '/promote': (context) => PromoteMentorScreen(),
          '/session_history': (context) => SessionHistoryScreen(),
          '/admin_sessions': (context) => AdminSessionScreen(),
        },
      ),
    );
  }

  // ✅ Loading Screen While App Starts
  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
