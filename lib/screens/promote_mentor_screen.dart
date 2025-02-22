/*
SERGE MUNEZA (20248/2022)
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mentor_provider.dart';

class PromoteMentorScreen extends StatefulWidget {
  @override
  _PromoteMentorScreenState createState() => _PromoteMentorScreenState();
}

class _PromoteMentorScreenState extends State<PromoteMentorScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    await Provider.of<MentorProvider>(context, listen: false).fetchUsers();
    await Provider.of<MentorProvider>(context, listen: false).fetchMentors();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mentorProvider = Provider.of<MentorProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Promote Users to Mentor")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : mentorProvider.users.isEmpty
              ? Center(child: Text("No users available."))
              : ListView.builder(
                  itemCount: mentorProvider.users.length,
                  itemBuilder: (context, index) {
                    final user = mentorProvider.users[index];
                    final bool isAlreadyMentor = mentorProvider.mentors.any((mentor) => mentor.email == user.email);

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(user.firstName + " " + user.lastName),
                        subtitle: Text(user.email),
                        trailing: isAlreadyMentor
                            ? Text("✅ Promoted", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                            : ElevatedButton(
                                onPressed: () async {
                                  await mentorProvider.promoteUserToMentor(user.email);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("${user.email} promoted to mentor!")),
                                  );
                                  setState(() => _isLoading = true);
                                  await _loadUsers();
                                },
                                child: Text("Promote"),
                              ),
                      ),
                    );
                  },
                ),
    );
  }
}
