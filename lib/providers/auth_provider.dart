// import 'package:flutter/material.dart';
// import 'package:bcrypt/bcrypt.dart';
// import '../models/user.dart';
// import '../services/db_helper.dart';

// class AuthProvider with ChangeNotifier {
//   User? _user;
//   bool _isAuthenticated = false;

//   bool get isAuthenticated => _isAuthenticated;
//   User? get user => _user;

//   // Signup (Secure Password Storage)
//   Future<bool> signup(User newUser) async {
//     String hashedPassword = BCrypt.hashpw(newUser.password.trim(), BCrypt.gensalt());

//     User securedUser = User(
//       firstName: newUser.firstName.trim(),
//       lastName: newUser.lastName.trim(),
//       email: newUser.email.trim(),
//       password: hashedPassword,
//       address: newUser.address.trim(),
//       bio: newUser.bio.trim(),
//       occupation: newUser.occupation.trim(),
//       expertise: newUser.expertise.trim(),
//       role: newUser.role,
//     );

//     int result = await DBHelper.insertUser(securedUser);
//     if (result > 0) {
//       _user = securedUser;
//       _isAuthenticated = true;
//       notifyListeners();
//       return true;
//     }
//     return false;
//   }

//   // Login (Check Hashed Password)
//   Future<bool> login(String email, String password) async {
//     User? storedUser = await DBHelper.getUserByEmail(email);
//     if (storedUser == null) return false;

//     if (BCrypt.checkpw(password.trim(), storedUser.password)) {
//       _user = storedUser;
//       _isAuthenticated = true;
//       notifyListeners();
//       return true;
//     }
//     return false;
//   }

//   // Logout
//   void logout() {
//     _isAuthenticated = false;
//     _user = null;
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';
import '../models/user.dart';
import '../services/db_helper.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  User? get user => _user;

  // ✅ Signup with Secure Password Storage
  Future<bool> signup(User newUser) async {
    try {
      String hashedPassword = BCrypt.hashpw(newUser.password.trim(), BCrypt.gensalt());

      User securedUser = User(
        firstName: newUser.firstName.trim(),
        lastName: newUser.lastName.trim(),
        email: newUser.email.trim(),
        password: hashedPassword,
        address: newUser.address.trim(),
        bio: newUser.bio.trim(),
        occupation: newUser.occupation.trim(),
        expertise: newUser.expertise.trim(),
        role: newUser.role,
      );

      int result = await DBHelper.insertUser(securedUser);
      if (result > 0) {
        _user = securedUser;
        _isAuthenticated = true;
        notifyListeners();
        print("✅ Signup successful for: ${_user!.email}");
        return true;
      }

      print("❌ Signup failed: Email already exists!");
      return false;
    } catch (e) {
      print("❌ Error in signup: $e");
      return false;
    }
  }

  // ✅ Login with Secure Password Check
  Future<bool> login(String email, String password) async {
    try {
      User? storedUser = await DBHelper.getUserByEmail(email.trim());
      if (storedUser == null) {
        print("❌ Login failed: User not found!");
        return false;
      }

      if (BCrypt.checkpw(password.trim(), storedUser.password)) {
        _user = storedUser;
        _isAuthenticated = true;
        notifyListeners();
        print("✅ Login successful for: ${_user!.email}, Role: ${_user!.role}");
        return true;
      }

      print("❌ Login failed: Incorrect password!");
      return false;
    } catch (e) {
      print("❌ Error in login: $e");
      return false;
    }
  }

  // ✅ Logout Function
  void logout() {
    _isAuthenticated = false;
    _user = null;
    notifyListeners();
    print("✅ User logged out successfully.");
  }
}
