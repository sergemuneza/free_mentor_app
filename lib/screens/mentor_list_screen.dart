/*
Developer: SERGE MUNEZA
 */

import 'package:flutter/material.dart';
import 'package:free_mentor/models/mentor.dart';
import 'package:provider/provider.dart';
import '../providers/mentor_provider.dart';
import '../providers/auth_provider.dart';
import 'mentor_detail_screen.dart';
import 'promote_mentor_screen.dart';
import 'request_session_screen.dart';
import 'approve_session_screen.dart';
import 'session_history_screen.dart';
import 'admin_session_screen.dart';

class MentorListScreen extends StatefulWidget {
  @override
  _MentorListScreenState createState() => _MentorListScreenState();
}

class _MentorListScreenState extends State<MentorListScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMentors();
  }

  Future<void> _loadMentors() async {
    await Provider.of<MentorProvider>(context, listen: false).fetchMentors();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mentorProvider = Provider.of<MentorProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final String userRole = authProvider.user?.role ?? "user";

    return Scaffold(
      appBar: AppBar(
        title: Text("🎓 Mentor List"),
        actions: [
          if (userRole == "admin")
            _buildIconButton(Icons.list, "All Sessions", AdminSessionScreen()), // ✅ Admins: View All Sessions
          if (userRole == "user")
            _buildIconButton(Icons.history, "Session History", SessionHistoryScreen()), // ✅ Users: View Session History
          if (userRole == "mentor")
            _buildIconButton(Icons.check_circle, "Approve Sessions", ApproveSessionScreen()), // ✅ Mentors: Approve Requests
          _buildIconButton(Icons.logout, "Logout", null, logout: true), // ✅ Logout button
        ],
      ),

      body: Column(
        children: [
          // ✅ Welcome message
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            color: Colors.blueAccent,
            child: Text(
              _getWelcomeMessage(userRole),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),

          if (userRole == "admin") // ✅ Admins only: Promote User to Mentor
            Padding(
              padding: EdgeInsets.all(8),
              child: ElevatedButton.icon(
                icon: Icon(Icons.person_add, size: 18),
                label: Text("Promote User to Mentor"),
                style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 12)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PromoteMentorScreen()),
                  ).then((_) => _loadMentors());
                },
              ),
            ),

          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : mentorProvider.mentors.isEmpty
                    ? _buildNoMentorsMessage()
                    : ListView.builder(
                        itemCount: mentorProvider.mentors.length,
                        itemBuilder: (context, index) {
                          final mentor = mentorProvider.mentors[index];
                          return _buildMentorCard(mentor, userRole);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // ✅ Function to build reusable icon buttons
  Widget _buildIconButton(IconData icon, String tooltip, Widget? screen, {bool logout = false}) {
    return IconButton(
      icon: Icon(icon, size: 28),
      tooltip: tooltip,
      onPressed: () {
        if (logout) {
          Provider.of<AuthProvider>(context, listen: false).logout();
          Navigator.pushReplacementNamed(context, "/login");
        } else if (screen != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
        }
      },
    );
  }

  // ✅ Function to show a friendly welcome message
  String _getWelcomeMessage(String role) {
    if (role == "admin") return "👋 Welcome Admin! You can promote users to mentors and manage sessions.";
    if (role == "mentor") return "🔹 Welcome Mentor! Check mentorship requests and approve sessions.";
    return "🌟 Welcome! Browse mentors and request mentorship sessions.";
  }

  // ✅ Function to build a styled "No mentors available" message
  Widget _buildNoMentorsMessage() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_off, size: 60, color: Colors.grey),
          SizedBox(height: 10),
          Text("No mentors available.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ✅ Function to build a well-designed mentor card
  Widget _buildMentorCard(Mentor mentor, String userRole) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(mentor.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(mentor.expertise, style: TextStyle(fontSize: 16, color: Colors.black54)),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MentorDetailScreen(mentor: mentor)));
        },
        trailing: userRole == "user"
            ? ElevatedButton.icon(
                icon: Icon(Icons.schedule, size: 16),
                label: Text("Request"),
                style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RequestSessionScreen(mentor: mentor)),
                  );
                },
              )
            : null,
      ),
    );
  }
}
