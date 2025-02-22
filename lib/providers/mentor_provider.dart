// import 'package:flutter/material.dart';
// import '../models/mentor.dart';
// import '../models/user.dart';
// import '../services/db_helper.dart';

// class MentorProvider with ChangeNotifier {
//   List<User> _users = [];
//   List<Mentor> _mentors = [];

//   List<User> get users => _users;
//   List<Mentor> get mentors => _mentors;

//   // ✅ Fetch all users (Admins only)
//   Future<void> fetchUsers() async {
//     _users = await DBHelper.getAllUsers();
//     notifyListeners();
//   }

//   // ✅ Fetch all mentors
//   Future<void> fetchMentors() async {
//     _mentors = await DBHelper.getAllMentors();
//     notifyListeners();
//   }

//   // ✅ Promote user to mentor
//   Future<void> promoteUserToMentor(String email) async {
//     int result = await DBHelper.promoteUserToMentor(email);
//     if (result > 0) {
//       print("✅ User promoted to mentor: $email");
//       await fetchMentors();
//       await fetchUsers();
//     } else {
//       print("❌ Failed to promote user: No matching email found!");
//     }
//   }

// }

import 'package:flutter/material.dart';
import '../models/mentor.dart';
import '../models/user.dart';
import '../services/db_helper.dart';

class MentorProvider with ChangeNotifier {
  List<User> _users = [];
  List<Mentor> _mentors = [];

  List<User> get users => _users;
  List<Mentor> get mentors => _mentors;

  // // ✅ Fetch all users (Admins only)
  // Future<void> fetchUsers() async {
  //   try {
  //     _users = await DBHelper.getAllUsers();
  //     notifyListeners();
  //   } catch (e) {
  //     print("❌ Error fetching users: $e");
  //   }
  // }
  // ✅ Fetch all users (Only non-admins)
Future<void> fetchUsers() async {
  try{
  _users = await DBHelper.getAllUsers();
  notifyListeners();
  } catch (e) {
    print("❌ Error fetching users: $e");
  }
}


  // ✅ Fetch all mentors
  Future<void> fetchMentors() async {
    try {
      _mentors = await DBHelper.getAllMentors();
      notifyListeners();
    } catch (e) {
      print("❌ Error fetching mentors: $e");
    }
  }
  // ✅ Fetch all mentors
// Future<void> fetchMentors() async {
//   _mentors = await DBHelper.getAllMentors();
//   notifyListeners();
// }


  // ✅ Prevent re-promoting a mentor & Promote user to mentor
  Future<void> promoteUserToMentor(String email) async {
    try {
      // ✅ Check if the user is already a mentor
      User? user = _users.firstWhere(
        (u) => u.email == email,
        orElse: () => User(email: "", firstName: "", lastName: "", password: "", address: "", bio: "", occupation: "", expertise: "", role: ""),
      );

      if (user.role == "mentor") {
        print("❌ User $email is already a mentor!");
        return;
      }

      int result = await DBHelper.promoteUserToMentor(email);
      if (result > 0) {
        print("✅ User promoted to mentor: $email");
        await fetchMentors();
        await fetchUsers();
      } else {
        print("❌ Failed to promote user: No matching email found!");
      }
    } catch (e) {
      print("❌ Error promoting user: $e");
    }
  }
}
