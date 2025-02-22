/*
SERGE MUNEZA (20248/2022)
 */
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/mentor.dart';
import '../models/session.dart';

class DBHelper {
  static Database? _database;

  // Initialize Database
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Create Database & Tables
  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'mentors_app.db');
    return openDatabase(
      path,
      version: 2, // Update version if modifying schema
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            firstName TEXT NOT NULL,
            lastName TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            address TEXT NOT NULL,
            bio TEXT NOT NULL,
            occupation TEXT NOT NULL,
            expertise TEXT NOT NULL,
            role TEXT DEFAULT 'user' NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE mentorship_sessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userEmail TEXT NOT NULL,
            mentorEmail TEXT NOT NULL,
            questions TEXT NOT NULL,
            isApproved INTEGER DEFAULT 0
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute("ALTER TABLE users ADD COLUMN role TEXT DEFAULT 'user'");
        }
      },
    );
  }

  // Insert New User (Signup)
  static Future<int> insertUser(User user) async {
    final db = await database;
    List<Map<String, dynamic>> existingUsers = await db.query(
      "users",
      where: "email = ?",
      whereArgs: [user.email],
    );

    if (existingUsers.isNotEmpty) {
      print("❌ Signup failed: Email '${user.email}' already exists!");
      return -1; // Indicate duplicate email
    }

    try {
      int result = await db.insert("users", user.toJson());
      print("✅ User inserted: ${user.email}");
      return result;
    } catch (e) {
      print("❌ Error inserting user: $e");
      return -1;
    }
  }

  // Get User by Email (Login)
  static Future<User?> getUserByEmail(String email) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      "users",
      where: "email = ?",
      whereArgs: [email],
    );

    if (results.isNotEmpty) {
      print("✅ User found: ${results.first['email']}");
      return User.fromJson(results.first);
    }
    print("❌ User not found: $email");
    return null;
  }

  // Fetch all users
static Future<List<User>> getAllUsers() async {
  final db = await database;
  List<Map<String, dynamic>> results = await db.query(
    "users",
    where: "role = ?", 
    whereArgs: ["user"],
  );

  return results.map((data) => User.fromJson(data)).toList();
}


  // Promote User to Mentor
  static Future<int> promoteUserToMentor(String email) async {
    final db = await database;
    int result = await db.update(
      "users",
      {"role": "mentor"},
      where: "email = ?",
      whereArgs: [email],
    );

    if (result > 0) {
      print("✅ User promoted to mentor: $email");
    } else {
      print("❌ Failed to promote user: No matching email found!");
    }

    return result;
  }

  // Get all mentors (Users with role = "mentor")
static Future<List<Mentor>> getAllMentors() async {
  final db = await database;
  List<Map<String, dynamic>> results = await db.query(
    "users",
    where: "role = ?",
    whereArgs: ["mentor"],
  );

  if (results.isEmpty) {
    print("❌ No mentors found in the database!");
  } else {
    print("✅ Mentors found:");
    for (var mentor in results) {
      print("Mentor: ${mentor['firstName']} ${mentor['lastName']} - Expertise: ${mentor['expertise']}");
    }
  }

  return results.map((data) => Mentor(
    id: data["id"],
    name: "${data["firstName"] ?? 'Unknown'} ${data["lastName"] ?? ''}".trim(),
    email: data["email"] ?? "", // ✅ Ensure email is included
    bio: data["bio"] ?? "No bio available",
    occupation: data["occupation"] ?? "Unknown occupation",
    expertise: data["expertise"] ?? "Unknown expertise",
  )).toList();
}


  // Insert Mentorship Session Request
  static Future<int> requestSession(MentorshipSession session) async {
    final db = await database;
    return await db.insert("mentorship_sessions", session.toJson());
  }

  // Get All Mentorship Session Requests for a Mentor
  static Future<List<MentorshipSession>> getMentorSessions(String mentorEmail) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      "mentorship_sessions",
      where: "mentorEmail = ?",
      whereArgs: [mentorEmail],
    );

    return results.map((data) => MentorshipSession.fromJson(data)).toList();
  }

  // Get All Mentorship Sessions for a User
  static Future<List<MentorshipSession>> getUserSessions(String userEmail) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      "mentorship_sessions",
      where: "userEmail = ?",
      whereArgs: [userEmail],
    );

    return results.map((data) => MentorshipSession.fromJson(data)).toList();
  }

  // Get All Mentorship Sessions (For Admin)
  static Future<List<MentorshipSession>> getAllSessions() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query("mentorship_sessions");

    return results.map((data) => MentorshipSession.fromJson(data)).toList();
  }

  // Approve Mentorship Session
  static Future<int> approveSession(int sessionId) async {
    final db = await database;
    return await db.update("mentorship_sessions", {"isApproved": 1}, where: "id = ?", whereArgs: [sessionId]);
  }

  // Reject Mentorship Session
  static Future<int> rejectSession(int sessionId) async {
    final db = await database;
    return await db.delete("mentorship_sessions", where: "id = ?", whereArgs: [sessionId]);
  }
}
