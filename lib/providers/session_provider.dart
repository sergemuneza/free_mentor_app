// import 'package:flutter/material.dart';
// import '../models/session.dart';
// import '../services/db_helper.dart';

// class SessionProvider with ChangeNotifier {
//   List<MentorshipSession> _userSessions = [];
//   List<MentorshipSession> _mentorSessions = [];

//   List<MentorshipSession> get userSessions => _userSessions;
//   List<MentorshipSession> get mentorSessions => _mentorSessions;

//   // ✅ Request a mentorship session
//   Future<void> requestSession(String userEmail, String mentorEmail, String questions) async {
//     try {
//       MentorshipSession newSession = MentorshipSession(
//         userEmail: userEmail,
//         mentorEmail: mentorEmail,
//         questions: questions,
//       );

//       await DBHelper.requestSession(newSession);
//       print("✅ Session requested successfully!");

//       await fetchUserSessions(userEmail); // Refresh user sessions
//     } catch (e) {
//       print("❌ Error requesting session: $e");
//     }
//   }

//   // ✅ Fetch all sessions for a user
//   Future<void> fetchUserSessions(String userEmail) async {
//     try {
//       _userSessions = await DBHelper.getUserSessions(userEmail);
//       print("✅ User sessions fetched: ${_userSessions.length}");
//       notifyListeners();
//     } catch (e) {
//       print("❌ Error fetching user sessions: $e");
//     }
//   }

//   // ✅ Fetch all sessions for a mentor
//   Future<void> fetchMentorSessions(String mentorEmail) async {
//     try {
//       _mentorSessions = await DBHelper.getMentorSessions(mentorEmail);
//       print("✅ Mentor sessions fetched: ${_mentorSessions.length}");
//       notifyListeners();
//     } catch (e) {
//       print("❌ Error fetching mentor sessions: $e");
//     }
//   }

//   // ✅ Approve a mentorship session
//   Future<void> approveSession(int sessionId, String mentorEmail) async {
//     try {
//       await DBHelper.approveSession(sessionId);
//       print("✅ Session $sessionId approved!");
//       await fetchMentorSessions(mentorEmail); // Refresh mentor sessions
//     } catch (e) {
//       print("❌ Error approving session: $e");
//     }
//   }
// }

import 'package:flutter/material.dart';
import '../models/session.dart';
import '../services/db_helper.dart';

class SessionProvider with ChangeNotifier {
  List<MentorshipSession> _sessions = [];

  List<MentorshipSession> get sessions => _sessions;

  // ✅ Request a Mentorship Session
  Future<void> requestSession(String userEmail, String mentorEmail, String questions) async {
    MentorshipSession newSession = MentorshipSession(
      userEmail: userEmail,
      mentorEmail: mentorEmail,
      questions: questions,
    );

    await DBHelper.requestSession(newSession);
    await fetchUserSessions(userEmail); // ✅ Refresh user session history
    notifyListeners();
  }

  // ✅ Fetch Sessions for a Mentor
  Future<void> fetchMentorSessions(String mentorEmail) async {
    _sessions = await DBHelper.getMentorSessions(mentorEmail);
    notifyListeners();
  }

  // ✅ Fetch Sessions for a User
  Future<void> fetchUserSessions(String userEmail) async {
    _sessions = await DBHelper.getUserSessions(userEmail);
    notifyListeners();
  }

  // ✅ Fetch All Sessions (For Admin)
  Future<void> fetchAllSessions() async {
    _sessions = await DBHelper.getAllSessions();
    notifyListeners();
  }

  // ✅ Approve a Mentorship Session
  Future<void> approveSession(int sessionId, String mentorEmail) async {
    await DBHelper.approveSession(sessionId);
    await fetchMentorSessions(mentorEmail); // ✅ Refresh after approval
  }

  // ✅ Reject a Mentorship Session
  Future<void> rejectSession(int sessionId, String mentorEmail) async {
    await DBHelper.rejectSession(sessionId);
    await fetchMentorSessions(mentorEmail); // ✅ Refresh after rejection
  }
}
