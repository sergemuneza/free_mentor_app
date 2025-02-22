// class Mentor {
//   final int? id;
//   final String name;
//   final String bio;
//   final String occupation;
//   final String expertise;

//   Mentor({
//     this.id,
//     required this.name,
//     required this.bio,
//     required this.occupation,
//     required this.expertise,
//   });

//   // Convert Mentor object to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "name": name,
//       "bio": bio,
//       "occupation": occupation,
//       "expertise": expertise,
//     };
//   }

//   // Convert JSON to Mentor object
//   factory Mentor.fromJson(Map<String, dynamic> json) {
//     return Mentor(
//       id: json["id"],
//       name: json["name"],
//       bio: json["bio"],
//       occupation: json["occupation"],
//       expertise: json["expertise"],
//     );
//   }
// }

class Mentor {
  final int? id;
  final String name;
  final String email; // ✅ Added email field
  final String bio;
  final String occupation;
  final String expertise;

  Mentor({
    this.id,
    required this.name,
    required this.email, // ✅ Now included
    required this.bio,
    required this.occupation,
    required this.expertise,
  });

  // ✅ Convert Mentor object to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email, // ✅ Ensure email is saved
      "bio": bio,
      "occupation": occupation,
      "expertise": expertise,
    };
  }

  // ✅ Convert JSON to Mentor object
  factory Mentor.fromJson(Map<String, dynamic> json) {
    return Mentor(
      id: json["id"],
      name: json["name"],
      email: json["email"] ?? "", // ✅ Ensure email is retrieved
      bio: json["bio"],
      occupation: json["occupation"],
      expertise: json["expertise"],
    );
  }
}
