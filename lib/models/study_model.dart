class Study {
  final String verse;
  final String studyText;
  final DateTime createdAt;

  Study({
    required this.verse,
    required this.studyText,
    required this.createdAt,
  });

  // Method to convert a Study object to a JSON map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'verse': verse,
      'studyText': studyText,
      'createdAt': createdAt.toUtc(), // Store as UTC
    };
  }

  // Factory method to create a Study object from a Firestore document
  factory Study.fromJson(Map<String, dynamic> json) {
    return Study(
      verse: json['verse'] as String,
      studyText: json['studyText'] as String,
      createdAt:
          (json['createdAt'] as dynamic)
              .toDate(), // Convert Firestore Timestamp to DateTime
    );
  }
}
