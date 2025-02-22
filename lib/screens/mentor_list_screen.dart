/*
SERGE MUNEZA (20248/2022)
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mentor_provider.dart';
import '../providers/auth_provider.dart';
import 'mentor_detail_screen.dart';
import 'promote_mentor_screen.dart';
import 'request_session_screen.dart';
import 'approve_session_screen.dart';
import 'session_history_screen.dart';
import 'admin_session_screen.dart'; // ✅ Import Admin Session Management

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
        title: Text("Mentors"),
        actions: [
          if (userRole == "admin") // ✅ Show "View All Sessions" for Admins
            IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminSessionScreen()),
                );
              },
            ),
          if (userRole == "user")
            IconButton(
              icon: Icon(Icons.history),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SessionHistoryScreen()),
                );
              },
            ),
          if (userRole == "mentor")
            IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ApproveSessionScreen()),
                );
              },
            ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (userRole == "admin") // ✅ Show "Promote to Mentor" only for Admins
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PromoteMentorScreen()),
                ).then((_) => _loadMentors());
              },
              child: Text("Promote User to Mentor"),
            ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : mentorProvider.mentors.isEmpty
                    ? Center(child: Text("No mentors available."))
                    : ListView.builder(
                        itemCount: mentorProvider.mentors.length,
                        itemBuilder: (context, index) {
                          final mentor = mentorProvider.mentors[index];
                          return ListTile(
                            title: Text(mentor.name),
                            subtitle: Text(mentor.expertise),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MentorDetailScreen(mentor: mentor),
                                ),
                              );
                            },
                            trailing: userRole == "user"
                                ? ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RequestSessionScreen(
                                                  mentor: mentor),
                                        ),
                                      );
                                    },
                                    child: Text("Request Session"),
                                  )
                                : null,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
