/*
Developer: SERGE MUNEZA
 */

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

  // // ✅ Approve a Mentorship Session
  // Future<void> approveSession(int sessionId, String mentorEmail) async {
  //   await DBHelper.approveSession(sessionId);
  //   await fetchMentorSessions(mentorEmail); // ✅ Refresh after approval
  // }

  // // ✅ Reject a Mentorship Session
  // Future<void> rejectSession(int sessionId, String mentorEmail) async {
  //   await DBHelper.rejectSession(sessionId);
  //   await fetchMentorSessions(mentorEmail); // ✅ Refresh after rejection
  // }

// ✅ Approve a session & refresh list
Future<void> approveSession(int sessionId, String mentorEmail) async {
  await DBHelper.approveSession(sessionId);
  await fetchMentorSessions(mentorEmail); // ✅ Refresh after approval
  notifyListeners();
}

// ✅ Reject a session & refresh list
Future<void> rejectSession(int sessionId, String mentorEmail) async {
  await DBHelper.rejectSession(sessionId);
  await fetchMentorSessions(mentorEmail); // ✅ Refresh after rejection
  notifyListeners();
}

}
