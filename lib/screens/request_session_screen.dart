import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../providers/auth_provider.dart';
import '../models/mentor.dart';

class RequestSessionScreen extends StatefulWidget {
  final Mentor mentor;

  RequestSessionScreen({required this.mentor});

  @override
  _RequestSessionScreenState createState() => _RequestSessionScreenState();
}

class _RequestSessionScreenState extends State<RequestSessionScreen> {
  final TextEditingController questionsController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Request Session")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Mentor: ${widget.mentor.name}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: questionsController,
              decoration: InputDecoration(labelText: "Enter your questions"),
              maxLines: 4,
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () async {
                      setState(() => _isLoading = true);
                      await sessionProvider.requestSession(
                        authProvider.user!.email,
                        widget.mentor.email,
                        questionsController.text.trim(),
                      );
                      setState(() => _isLoading = false);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Session request sent!")));
                      Navigator.pop(context);
                    },
                    child: Text("Request Session"),
                  ),
          ],
        ),
      ),
    );
  }
}
