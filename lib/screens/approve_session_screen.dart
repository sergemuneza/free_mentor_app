/*
SERGE MUNEZA (20248/2022)
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../providers/auth_provider.dart';

class ApproveSessionScreen extends StatefulWidget {
  @override
  _ApproveSessionScreenState createState() => _ApproveSessionScreenState();
}

class _ApproveSessionScreenState extends State<ApproveSessionScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final mentor = Provider.of<AuthProvider>(context, listen: false).user;
    if (mentor != null) {
      await Provider.of<SessionProvider>(context, listen: false).fetchMentorSessions(mentor.email);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final mentorEmail = authProvider.user?.email ?? "";

    return Scaffold(
      appBar: AppBar(title: Text("Mentorship Requests")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : sessionProvider.sessions.isEmpty
              ? Center(child: Text("No pending session requests."))
              : ListView.builder(
                  itemCount: sessionProvider.sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessionProvider.sessions[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text("Request from: ${session.userEmail}"),
                        subtitle: Text(session.questions),
                        trailing: session.isApproved
                            ? Text("✅ Approved", style: TextStyle(color: Colors.green))
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      await sessionProvider.approveSession(session.id!, mentorEmail);
                                      _loadSessions(); // ✅ Refresh the session list
                                    },
                                    child: Text("Approve"),
                                  ),
                                  SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await sessionProvider.rejectSession(session.id!, mentorEmail);
                                      _loadSessions(); // ✅ Refresh after rejection
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    child: Text("Reject"),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
    );
  }
}
