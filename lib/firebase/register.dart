class Register {
  String fullName;
  String email;
  String password;
  String phoneNumber;
  String userType;
  DateTime timestamp = DateTime.now();

  Register({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.userType,
    required this.timestamp,
  });

  factory Register.fromJson(Map<String, dynamic> doc, String docId) {
      print("Firestore Document Data: $doc");
    return Register(
      fullName: doc['fullName'] ?? "No Name",
      email: doc['email'] ?? "No Email",
      password: doc['password'] ?? "No Password",
      phoneNumber: doc['phoneNumber'] ?? "No Phone Number",
      userType: doc['userType'],
      timestamp: doc['timestamp'].toDate(),
    );
  }
  Map<String, dynamic> tojson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'userType': userType,
      'timestamp': timestamp,
    };
  }
}