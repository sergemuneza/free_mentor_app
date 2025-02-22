import 'package:flutter/material.dart';
import '../models/mentor.dart';

class MentorDetailScreen extends StatelessWidget {
  final Mentor mentor;

  MentorDetailScreen({required this.mentor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(mentor.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bio:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(mentor.bio),
            SizedBox(height: 10),
            Text("Occupation:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(mentor.occupation),
            SizedBox(height: 10),
            Text("Expertise:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(mentor.expertise),
          ],
        ),
      ),
    );
  }
}
