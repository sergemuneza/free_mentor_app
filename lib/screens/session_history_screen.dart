import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../providers/auth_provider.dart';

class SessionHistoryScreen extends StatefulWidget {
  @override
  _SessionHistoryScreenState createState() => _SessionHistoryScreenState();
}

class _SessionHistoryScreenState extends State<SessionHistoryScreen> {
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      if (user != null) {
        Provider.of<SessionProvider>(context, listen: false).fetchUserSessions(user.email);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Session History")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : sessionProvider.sessions.isEmpty
              ? Center(child: Text("No past mentorship sessions."))
              : ListView.builder(
                  itemCount: sessionProvider.sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessionProvider.sessions[index];
                    return ListTile(
                      title: Text("Mentor: ${session.mentorEmail}"),
                      subtitle: Text(session.questions),
                      trailing: session.isApproved
                          ? Text("✅ Approved", style: TextStyle(color: Colors.green))
                          : Text("⏳ Pending", style: TextStyle(color: Colors.orange)),
                    );
                  },
                ),
    );
  }
}
