/*
SERGE MUNEZA (20248/2022)
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController expertiseController = TextEditingController();
  String role = "user"; // Default role
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Signup")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(controller: firstNameController, decoration: InputDecoration(labelText: "First Name")),
                TextFormField(controller: lastNameController, decoration: InputDecoration(labelText: "Last Name")),
                TextFormField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
                TextFormField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
                TextFormField(controller: addressController, decoration: InputDecoration(labelText: "Address")),
                TextFormField(controller: bioController, decoration: InputDecoration(labelText: "Bio")),
                TextFormField(controller: occupationController, decoration: InputDecoration(labelText: "Occupation")),
                TextFormField(controller: expertiseController, decoration: InputDecoration(labelText: "Expertise")),

                DropdownButton<String>(
                  value: role,
                  items: ["user", "admin"].map((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value.toUpperCase()));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      role = newValue!;
                    });
                  },
                ),

                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      User newUser = User(
                        firstName: firstNameController.text.trim(),
                        lastName: lastNameController.text.trim(),
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                        address: addressController.text.trim(),
                        bio: bioController.text.trim(),
                        occupation: occupationController.text.trim(),
                        expertise: expertiseController.text.trim(),
                        role: role,
                      );

                      bool success = await authProvider.signup(newUser);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Signup successful! Please log in.")),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Signup failed. Email already exists.")),
                        );
                      }
                    }
                  },
                  child: Text("Signup"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
