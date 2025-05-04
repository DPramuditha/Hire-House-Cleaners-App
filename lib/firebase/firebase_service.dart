import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:house_cleaners_app/firebase/add_house_info.dart';
import 'package:house_cleaners_app/firebase/add_post.dart';
import 'package:house_cleaners_app/firebase/cleaner_infomation.dart';
import 'package:house_cleaners_app/firebase/customer_feedback.dart';
import 'package:house_cleaners_app/firebase/register.dart';

class FirebaseService {

  final CollectionReference _RegisterCustomer = FirebaseFirestore.instance.collection("RegisterCustomer");

  Future<void> addCustomer(String fullname, String email, String password, String phoneNumber, String userType, DateTime time) async {
    try {
      final addcustomer = Register(
        fullName: fullname, 
        email: email, 
        password: password, 
        phoneNumber: phoneNumber, 
        userType: userType,
        timestamp: time,

        );

      final Map<String, dynamic> data = addcustomer.tojson();
      await _RegisterCustomer.add(data);
      print("✅ Customer added successfully!");
    } catch (e) {
      print("❌ Failed to add customer: $e");
    }
  }

  Stream<List<Register>> getRegisterCustomer() {
    return _RegisterCustomer.snapshots().map((snapshot) => snapshot.docs.map((doc) => Register.fromJson(doc.data() as Map<String, dynamic>,doc.id)).toList());
  }



  final CollectionReference _AddCustomerPost = FirebaseFirestore.instance.collection("CustomerPosts");

  Future<void> addCustomerPost(String title, String location, String typeOfFloor, String description,int numberOfBathroom,int numberOfRoom,  String price, DateTime time, String userEmail, String imageUrl) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String userEmail = user?.email ?? "default@example.com";

      final addcustomerpost = AddPost(
        title: title, 
        location: location, 
        typeOfFloor: typeOfFloor, 
        description: description, 
        numberOfBathroom: numberOfBathroom,
        numberOfRoom: numberOfRoom,
        price: price,
        email: userEmail,
        status: "Pending",
        assignedCleaner: "No Cleaner",
        imageUrl: "No Image",
        timestamp: time,

        );

      final Map<String, dynamic> data = addcustomerpost.tojson();
      await _AddCustomerPost.add(data);
      print("✅ Customer Post added successfully!");
    } catch (e) {
      print("❌ Failed to add customer post: $e");
    }
  }
  
  Stream<List<AddPost>> getCustomerPost() {
    return _AddCustomerPost.snapshots().map((snapshot) => snapshot.docs.map((doc) => AddPost.fromJson(doc.data() as Map<String, dynamic>,doc.id)).toList());
  }




  final CollectionReference _AddHouseInfo = FirebaseFirestore.instance.collection("HouseInfomation");

  Future<void> AddHouseInfomation(String houseName, String houseAddress, int numberOfRoom, int numberOfBathroom, String floorType, String email) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String email = user?.email ?? "";

      final addhouseinfo = AddHouseInfo(
        houseName: houseName,
        houseAddress: houseAddress,
        numberOfRoom: numberOfRoom,
        numberOfBathroom: numberOfBathroom,
        floorType: floorType,
        email: email
        );

      final Map<String, dynamic> data = addhouseinfo.tojson();
      await _AddHouseInfo.add(data);
      print("✅ House information added successfully!");
    } catch (e) {
      print("❌ Failed to add house information: $e");
    }
  }

  // Stream<List<AddHouseInfo>> getHouseInformation(String s) {
  //   return _AddHouseInfo.snapshots().map((snapshot) => snapshot.docs.map((doc) => AddHouseInfo.fromJson(doc.data() as Map<String, dynamic>,doc.id)).toList());
  // }
  Stream<List<AddHouseInfo>> getHouseInformation(String email) {
  return FirebaseFirestore.instance
      .collection("HouseInfomation") // ✅ Correct collection name
      .where("email", isEqualTo: email) // ✅ Filter documents by email
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => AddHouseInfo.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList());
}




  final CollectionReference _AddCleanerInfo = FirebaseFirestore.instance.collection("AddCleanerInfo");
  Future<void> AddCleanerInfomation(String contactNumber, String address, String yearsOfExperience, String availabilityDays, String certifications, String email) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String email = user?.email ?? "";

      final addcleanerinfo = CleanerInfomation(
        contactNumber: contactNumber, 
        address: address, 
        yearsOfExperience: yearsOfExperience,
        availabilityDays: availabilityDays,
        certifications: certifications,
        email: email
           );

      final Map<String, dynamic> data = addcleanerinfo.tojson();
      await _AddCleanerInfo.add(data);
      print("✅ Cleaner information added successfully!");
    } catch (e) {
      print("❌ Failed to add cleaner information: $e");
    }
  }

  // Stream<List<CleanerInfomation>> getCleanerInformation(String s) {
  //   return _AddCleanerInfo.snapshots().map((snapshot) => snapshot.docs.map((doc) => CleanerInfomation.fromJson(doc.data() as Map<String, dynamic>,doc.id)).toList());
  // }

  Stream<List<CleanerInfomation>> getCleanerInformation(String email) {
  return FirebaseFirestore.instance
      .collection("AddCleanerInfo") // ✅ Use correct collection name
      .where("email", isEqualTo: email) // ✅ Filter only logged-in cleaner's details
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => CleanerInfomation.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList());
}


  final CollectionReference _CustomerFeedback = FirebaseFirestore.instance.collection("CustomerFeedback");
  Future<void> addCustomerFeedback(String email, String review, DateTime date, String currentUser) async {
    try {
      final addcustomerfeedback = CustomerFeedback(
        email: email, 
        review: review, 
        timestamp: date, 
        currentUser: currentUser
        );

      final Map<String, dynamic> data = addcustomerfeedback.toJson();
      await _CustomerFeedback.add(data);
      print("✅ Customer feedback added successfully!");
    } catch (e) {
      print("❌ Failed to add customer feedback: $e");
    }
  }

  Stream<List<CustomerFeedback>> getCustomerFeedback() {
    return _CustomerFeedback.snapshots().map((snapshot) => snapshot.docs.map((doc) => CustomerFeedback.fromJson(doc.data() as Map<String, dynamic>,doc.id)).toList());
  }



  Future<void> deletePost(String email) async {
  try {
    print("Deleting post for email: $email");

    // Query Firestore to find the document with the given email
    QuerySnapshot querySnapshot = await _AddCustomerPost.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
        print("✅ Post deleted successfully for email: $email");
      }
    } else {
      print("⚠️ No post found for email: $email");
    }
  } catch (e) {
    print("❌ Error deleting post: $e");
  }
}

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Future<void> SignWithGoogle() async{
  //   try{
  //     final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
  //     if(googleSignInAccount == null){
  //       print("❌ Google sign in failed!");
  //       return;
  //     }
  //     final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //     await _auth.signInWithCredential(credential);
  //     print("✅ Google sign in successful!");

  //   }

  //   on FirebaseAuthException catch(e){
  //     print("❌ Error signing in with Google: $e");
  //   }
  //   catch(e){
  //     print("❌ Error signing in with Google: $e");
  //   }
  // }

Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        print("❌ Google sign-in canceled by user.");
        return null; // Return null if sign-in was canceled
      }

      final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print("❌ Google authentication failed: Missing token");
        return null; // Return null if tokens are missing
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print("❌ Error signing in with Google: $e");
      return null; // Return null on error
    }
  }



}




















  // void FirebaseConnection() async {
  // try {
  //   await FirebaseFirestore.instance.collection("TestCollection").add({
  //     'testKey': 'testValue',
  //     'timestamp': FieldValue.serverTimestamp(),
  //   });
  //   print("✅ Firebase connection successful! Document added.");
  // } catch (e) {

  //   print("❌ Firebase connection failed: $e");
  // }
  // }
  
