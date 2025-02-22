class MentorshipSession {
  final int? id;
  final String userEmail; // The user requesting mentorship
  final String mentorEmail; // The mentor receiving request
  final String questions; // The user's questions
  final bool isApproved; // If mentor has approved the session

  MentorshipSession({
    this.id,
    required this.userEmail,
    required this.mentorEmail,
    required this.questions,
    this.isApproved = false,
  });

  // Convert Session object to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userEmail": userEmail,
      "mentorEmail": mentorEmail,
      "questions": questions,
      "isApproved": isApproved ? 1 : 0, // Store boolean as int
    };
  }

  // Convert JSON to Session object
  factory MentorshipSession.fromJson(Map<String, dynamic> json) {
    return MentorshipSession(
      id: json["id"],
      userEmail: json["userEmail"],
      mentorEmail: json["mentorEmail"],
      questions: json["questions"],
      isApproved: json["isApproved"] == 1,
    );
  }
}
