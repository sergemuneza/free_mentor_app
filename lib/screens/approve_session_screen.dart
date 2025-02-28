/*
Developer: SERGE MUNEZA
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      final mentor = Provider.of<AuthProvider>(context, listen: false).user!;
      Provider.of<SessionProvider>(context, listen: false).fetchMentorSessions(mentor.email).then((_) {
        setState(() => _isLoading = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);

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
                        trailing: session.isApproved == 1
                            ? Text("✅ Approved", style: TextStyle(color: Colors.green))
                            : session.isApproved == -1
                                ? Text("❌ Rejected", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          setState(() => _isLoading = true);
                                          await sessionProvider.approveSession(session.id!, session.mentorEmail);
                                          setState(() => _isLoading = false);
                                        },
                                        child: Text("Approve"),
                                      ),
                                      SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () async {
                                          setState(() => _isLoading = true);
                                          await sessionProvider.rejectSession(session.id!, session.mentorEmail);
                                          setState(() => _isLoading = false);
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
