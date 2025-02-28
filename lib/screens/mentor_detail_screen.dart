/*
Developer: SERGE MUNEZA
 */

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
            // ✅ Welcome message
            Center(
              child: Text(
                "👋 Welcome to the Mentor Details Screen",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                textAlign: TextAlign.center,
              ),
            ),
            Divider(thickness: 1, height: 20),

            // ✅ Mentor details section
            _buildDetailSection("👤 Name", mentor.name),
            _buildDetailSection("📖 Bio", mentor.bio),
            _buildDetailSection("💼 Occupation", mentor.occupation),
            _buildDetailSection("🎓 Expertise", mentor.expertise),

            // ✅ Action button (optional for further interactions)
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to the mentor list
                },
                child: Text("Back to Mentors"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Reusable method to create labeled sections
  Widget _buildDetailSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          Text(content, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
