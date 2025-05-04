class CleanerInfomation {
  String contactNumber;
  String address;
  String yearsOfExperience;
  String availabilityDays;
  String certifications;
  String email;

  CleanerInfomation({
    required this.contactNumber,
    required this.address,
    required this.yearsOfExperience,
    required this.availabilityDays,
    required this.certifications,
    required this.email,
  });


  factory CleanerInfomation.fromJson(Map<String, dynamic> doc, String docId) {
    print("Firestore Document Data: $doc");
    return CleanerInfomation(
      contactNumber: doc['contactNumber'] ?? "No Contact Number",
      address: doc['address'] ?? "No Address",
      yearsOfExperience: doc['yearsOfExperience'] ?? "No Years of Experience",
      availabilityDays: doc['availabilityDays'] ?? "No Availability Days",
      certifications: doc['certifications'] ?? "No Certifications",
      email: doc['email'] ?? "No Email",
    );
  }


  Map<String, dynamic> tojson() {
    return {
      'contactNumber': contactNumber,
      'address': address,
      'yearsOfExperience': yearsOfExperience,
      'availabilityDays': availabilityDays,
      'certifications': certifications,
      'email': email,
    };
  }

}