// /*
// SERGE MUNEZA (20248/2022)
//  */

// import 'package:flutter/material.dart';
// import 'package:free_mentor/providers/session_provider.dart';
// import 'package:free_mentor/screens/admin_session_screen.dart';
// import 'package:free_mentor/screens/promote_mentor_screen.dart';
// import 'package:free_mentor/screens/session_history_screen.dart';
// import 'package:provider/provider.dart';
// import 'providers/auth_provider.dart';
// import 'providers/mentor_provider.dart';
// import 'services/db_helper.dart'; 
// import 'screens/login_screen.dart';
// import 'screens/signup_screen.dart';
// import 'screens/mentor_list_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   // Debugging: Log mentors at app start
//   await DBHelper.getAllMentors().then((mentors) {
//     print("✅ Mentors in database: ${mentors.length}");
//     for (var mentor in mentors) {
//       print("Mentor: ${mentor.name} - Expertise: ${mentor.expertise}");
//     }
//   });

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => MentorProvider()),
//         ChangeNotifierProvider(create: (_) => SessionProvider()),
//       ],
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "Free Mentors",
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: LoginScreen(),
//       routes: {
//          '/login': (context) => LoginScreen(), 
//         '/signup': (context) => SignupScreen(),
//         '/mentors': (context) => MentorListScreen(),
//         '/promote': (context) => PromoteMentorScreen(),
//         '/session_history': (context) => SessionHistoryScreen(), 
//          '/admin_sessions': (context) => AdminSessionScreen(), 
//       },
//     );
//   }
// }
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
  
  await DBHelper.deleteEmptyUsers(); // ✅ Remove empty users at startup
  await _initializeApp(); // ✅ Fetch mentors before app starts

  runApp(MyApp());
}

// ✅ Initialize Database & Fetch Mentors Before App Starts
Future<void> _initializeApp() async {
  try {
    await DBHelper.getAllMentors().then((mentors) {
      debugPrint("✅ Mentors in database: ${mentors.length}");
      for (var mentor in mentors) {
        debugPrint("Mentor: ${mentor.name} - Expertise: ${mentor.expertise}");
      }
    });
  } catch (e) {
    debugPrint("❌ Error initializing app: $e");
    throw e;
  }
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
              return _buildLoadingScreen(); // ✅ Show loading before initialization
            }
            return WelcomeScreen(); // ✅ Load WelcomeScreen first
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

