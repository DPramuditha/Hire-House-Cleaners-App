class AddPost {
  String title;
  String location;
  String typeOfFloor;
  String description;
  int numberOfRoom;
  int numberOfBathroom;
  String price;
  String email;
  String status;
  String assignedCleaner;
  String imageUrl;
  DateTime timestamp = DateTime.now();

  AddPost({
    required this.title,
    required this.location,
    required this.typeOfFloor,
    required this.description,
    required this.numberOfRoom,
    required this.numberOfBathroom,
    required this.price,
    required this.email,
    this.status = "Pending",
    required this.assignedCleaner,
    required this.imageUrl,
    required this.timestamp,
  });

factory AddPost.fromJson(Map<String, dynamic> doc, String docId) {
    print("Firestore Document Data: $doc");
  return AddPost(
    title: doc['title'] ?? "No Title",
    location: doc['location'] ?? "No Location",
    typeOfFloor: doc['typeOfFloor'] ?? "No Type of Floor",
    description: doc['description'] ?? "No Description",
    price: doc['price'] ?? "No Price",
    numberOfRoom: doc['numberOfRoom'] ?? 0,
    numberOfBathroom: doc['numberOfBathroom'] ?? 0,
    email: doc['email'] ?? "No Email",
    status: doc['status'] ?? "pending",
    assignedCleaner: doc['assignedCleaner'] ?? "No Cleaner",
    imageUrl: doc['imageUrl'] ?? "No Image",
    timestamp: doc['timestamp'].toDate(),
  );
}


Map<String, dynamic> tojson() {
  return {
    'title': title,
    'location': location,
    'typeOfFloor': typeOfFloor,
    'description': description,
    'price': price,
    'email': email,
    'status': status,
    'assignedCleaner': assignedCleaner,
    'numberOfRoom': numberOfRoom,
    'numberOfBathroom': numberOfBathroom,
    'imageUrl': imageUrl,
    'timestamp': timestamp,
  };
}

}