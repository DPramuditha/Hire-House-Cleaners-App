class CustomerFeedback {
  String email;
  String review;
  DateTime timestamp = DateTime.now();
  String currentUser;

  CustomerFeedback({
    required this.email,
    required this.review,
    required this.timestamp,
    required this.currentUser,
  });


  factory CustomerFeedback.fromJson(Map<String, dynamic> doc, String docId) {
    print("Firestore Document Data: $doc");
    return CustomerFeedback(
      email: doc['email'] ?? "No Email",
      review: doc['review'] ?? "No Review",
      timestamp: doc['date'].toDate() ?? DateTime.now(),
      currentUser: doc['currentUser'] ?? "No Current User",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'review': review,
      'date': timestamp,
      'currentUser': currentUser,
    };
  }
}