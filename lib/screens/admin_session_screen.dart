/*
Developer: SERGE MUNEZA
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

  // ✅ Fetch all sessions for admin
  Future<void> _loadSessions() async {
    await Provider.of<SessionProvider>(context, listen: false).fetchAllSessions();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
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
              : RefreshIndicator(
                  onRefresh: _loadSessions, // ✅ Pull to refresh feature
                  child: ListView.separated(
                    padding: EdgeInsets.all(12),
                    itemCount: sessionProvider.sessions.length,
                    separatorBuilder: (context, index) => Divider(), // ✅ Adds separation between items
                    itemBuilder: (context, index) {
                      final session = sessionProvider.sessions[index];

                      // ✅ Correctly display Approved, Pending, and Rejected statuses
                      String statusText;
                      Color statusColor;

                      switch (session.isApproved) {
                        case 1:
                          statusText = "✅ Approved";
                          statusColor = Colors.green;
                          break;
                        case -1:
                          statusText = "❌ Rejected";
                          statusColor = Colors.red;
                          break;
                        default:
                          statusText = "⏳ Pending";
                          statusColor = Colors.orange;
                          break;
                      }

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12),
                          title: Text("User: ${session.userEmail}", style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text("Mentor: ${session.mentorEmail}"),
                              Text("Questions: ${session.questions}"),
                            ],
                          ),
                          trailing: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
