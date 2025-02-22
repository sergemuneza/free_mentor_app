/*
SERGE MUNEZA (20248/2022)
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';

class AdminSessionScreen extends StatefulWidget {
  @override
  _AdminSessionScreenState createState() => _AdminSessionScreenState();
}

class _AdminSessionScreenState extends State<AdminSessionScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    await Provider.of<SessionProvider>(context, listen: false).fetchAllSessions();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("All Mentorship Sessions")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : sessionProvider.sessions.isEmpty
              ? Center(child: Text("No mentorship sessions found."))
              : ListView.builder(
                  itemCount: sessionProvider.sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessionProvider.sessions[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text("User: ${session.userEmail}"),
                        subtitle: Text("Mentor: ${session.mentorEmail}\nQuestions: ${session.questions}"),
                        trailing: session.isApproved
                            ? Text("✅ Approved", style: TextStyle(color: Colors.green))
                            : Text("⏳ Pending", style: TextStyle(color: Colors.orange)),
                      ),
                    );
                  },
                ),
    );
  }
}
