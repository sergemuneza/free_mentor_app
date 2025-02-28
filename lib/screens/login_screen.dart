// /*
// SERGE MUNEZA (20248/2022)
//  */

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import 'mentor_list_screen.dart';
// import 'signup_screen.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: Text("Login")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: emailController,
//                 decoration: InputDecoration(labelText: "Email"),
//                 validator: (value) => value!.isEmpty ? "Enter your email" : null,
//               ),
//               TextFormField(
//                 controller: passwordController,
//                 decoration: InputDecoration(labelText: "Password"),
//                 obscureText: true,
//                 validator: (value) => value!.isEmpty ? "Enter your password" : null,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     bool success = await authProvider.login(
//                       emailController.text,
//                       passwordController.text,
//                     );
//                     if (success) {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => MentorListScreen()),
//                       );
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text("Invalid Email or Password")),
//                       );
//                     }
//                   }
//                 },
//                 child: Text("Login"),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => SignupScreen()),
//                   );
//                 },
//                 child: Text("Don't have an account? Sign up"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

/*
SERGE MUNEZA (20248/2022)
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'mentor_list_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false; // ✅ Loading state

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Welcome Back! 👋",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                // ✅ Email Field
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter your email";
                    } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                        .hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                // ✅ Password Field
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter your password";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // ✅ Login Button with Loading Indicator
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus(); // ✅ Hide keyboard
                            setState(() => _isLoading = true);

                            bool success = await authProvider.login(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );

                            setState(() => _isLoading = false);

                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => MentorListScreen()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Invalid Email or Password"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Login"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 15),

                // ✅ Signup Redirect
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  child: Text("Don't have an account? Sign up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
