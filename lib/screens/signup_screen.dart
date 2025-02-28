/*
Developer: SERGE MUNEZA
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
         
              _buildTextField(
                controller: firstNameController,
                label: "First Name",
                icon: Icons.person,
                validator: (value) =>
                    value!.isEmpty ? "Enter your first name" : null,
              ),

             
              _buildTextField(
                controller: lastNameController,
                label: "Last Name",
                icon: Icons.person_outline,
                validator: (value) =>
                    value!.isEmpty ? "Enter your last name" : null,
              ),

              _buildTextField(
                controller: emailController,
                label: "Email",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) return "Enter your email";
                  if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                      .hasMatch(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),

              _buildTextField(
                controller: passwordController,
                label: "Password",
                icon: Icons.lock,
                isObscure: true,
                validator: (value) => value!.length < 6
                    ? "Password must be at least 6 characters"
                    : null,
              ),

              _buildTextField(
                controller: addressController,
                label: "Address",
                icon: Icons.home,
                validator: (value) =>
                    value!.isEmpty ? "Enter your address" : null,
              ),

              _buildTextField(
                controller: bioController,
                label: "Bio",
                icon: Icons.description,
                validator: (value) => value!.isEmpty ? "Enter your bio" : null,
              ),

              _buildTextField(
                controller: occupationController,
                label: "Occupation",
                icon: Icons.work,
                validator: (value) =>
                    value!.isEmpty ? "Enter your occupation" : null,
              ),

              _buildTextField(
                controller: expertiseController,
                label: "Expertise",
                icon: Icons.star,
                validator: (value) =>
                    value!.isEmpty ? "Enter your expertise" : null,
              ),


              _buildRoleDropdown(),

              SizedBox(height: 20),

              _buildSignupButton(authProvider),

              SizedBox(height: 10),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text("Already have an account? Log in"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isObscure = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        obscureText: isObscure,
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: DropdownButtonFormField<String>(
        value: role,
        decoration: InputDecoration(
          labelText: "Select Role",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: ["user", "admin"].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value.toUpperCase()),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            role = newValue!;
          });
        },
      ),
    );
  }

  Widget _buildSignupButton(AuthProvider authProvider) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)), // Rounded button
      ),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
        
          FocusScope.of(context).unfocus();

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
      child: Text("Sign Up",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
