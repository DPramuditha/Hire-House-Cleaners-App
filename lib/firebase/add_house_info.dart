class AddHouseInfo {
  String houseName;
  String houseAddress;
  int numberOfRoom;
  int numberOfBathroom;
  String floorType;
  String email;

  AddHouseInfo({
    required this.houseName,
    required this.houseAddress,
    required this.numberOfRoom,
    required this.numberOfBathroom,
    required this.floorType,
    required this.email,
  });

  factory AddHouseInfo.fromJson(Map<String, dynamic> doc, String docId) {
    print("Firestore Document Data: $doc");
    
    return AddHouseInfo(
      houseName: doc['houseName'] ?? "No House Name",
      houseAddress: doc['houseAddress'] ?? "No House Address",
      numberOfRoom: doc['numberOfRoom'] ?? 0,
      numberOfBathroom: doc['numberOfBathroom'] ?? 0,
      floorType: doc['floorType'] ?? "No Floor Type",
      email: doc['email'] ?? "No Email",
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'houseName': houseName,
      'houseAddress': houseAddress,
      'numberOfRoom': numberOfRoom,
      'numberOfBathroom': numberOfBathroom,
      'floorType': floorType,
      'email': email,
    };
  } 
}