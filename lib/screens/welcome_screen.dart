/*
Developer: SERGE MUNEZA
 */

import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          // ✅ Prevents overflow on small screens
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80),

              // ✅ App Logo (Optional: Add your own logo)
              Image.asset(
                'assets/images/logo.png', // Make sure you have a logo in assets
                height: 160,
                width: 160,
              ),

              SizedBox(height: 20),

              Text(
                "WELCOME TO THE FREE MENTORS APP",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26, // ✅ Increased for better readability
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),

              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Free Mentors is a mobile application designed to connect young individuals with "
                  "experienced professionals for free mentorship sessions. Users can sign up, "
                  "request mentorship, and interact with mentors.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ),

              SizedBox(height: 30),

              Text(
                "Developed by:",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),

              SizedBox(height: 25),

              // Developer: SERGE MUNEZA
              _buildDeveloperInfo(
                imagePath: 'assets/images/serge.jpg',
                name: 'SERGE MUNEZA',
              ),

              SizedBox(height: 40),

              _buildButton(
                text: "Login",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              ),

              SizedBox(height: 15),

              // ✅ Animated Signup Button
              _buildButton(
                text: "Sign Up",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupScreen()));
                },
              ),

              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Developer Info Widget (Image + Name)
  Widget _buildDeveloperInfo(
      {required String imagePath, required String name}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(imagePath),
        ),
        SizedBox(width: 10),
        Text(
          name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // ✅ Reusable Button Widget
  Widget _buildButton({required String text, required VoidCallback onTap}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
        elevation: 5, // ✅ Add elevation for effect
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)), // ✅ Rounded buttons
      ),
      onPressed: onTap,
      child: Text(text,
          style: TextStyle(
              color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
