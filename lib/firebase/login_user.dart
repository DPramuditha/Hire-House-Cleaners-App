import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:house_cleaners_app/customer/pages_move.dart';
import 'package:house_cleaners_app/house_cleaners/cleaners_dashboard.dart';

class LoginUser {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> Registeruser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("✅ User registered successfully! ${userCredential.user?.email}"); 
    } 
    on FirebaseAuthException catch (e) {
      print("❌ FirebaseAuthException: ${e.message}");

      if (e.code == 'email-already-in-use') {
        throw Exception("The email address is already registered.");
      } else if (e.code == 'weak-password') {
        throw Exception("Password should be at least 6 characters.");
      } else if (e.code == 'invalid-email') {
        throw Exception("Invalid email format.");
      } else {
        throw Exception("Failed to create user.");
      }
    }
    
    catch (e) {
      print("❌ Failed to register user: $e");
      throw Exception("Failed to register user.");
    }
  }
  

  Future<void> Loginuser({
    required String email,
    required String password,
  }) async {
    try {
       await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("✅ User logged in successfully! ${email}");
    } 
    on FirebaseAuthException catch (e) {
      print("❌ FirebaseAuthException: ${e.message}");

      if (e.code == 'user-not-found') {
        throw Exception("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        throw Exception("Wrong password provided for that user.");
      } else {
        throw Exception("Failed to login.");
      }
    } 
    catch (e) {
      print("❌ Failed to login user: $e");
      throw Exception("Failed to login user.");
    }
  }


  Future<void> Logoutuser() async {
    try {
      await _auth.signOut();
      print("✅ User logged out successfully!");
    } catch (e) {
      print("❌ Failed to logout user: $e");
      throw Exception("Failed to logout user.");
    }
  }

}


Future<void> checkUserTypeAndNavigate(BuildContext context, String email) async {
  try {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection("RegisterCustomer").doc(email).get();

    if (userDoc.exists) {
      String userType = userDoc["userType"];

      if (userType == "Customer") {
        print("✅User is a customer");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CleanersDashboard()),
        );
      } else if (userType == "Cleaner") {
        print("✅User is a cleaner");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PagesMove()),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Invalid user type"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok"),
                ),
              ],
            );
          },
        );
      }
    } else {
      print("User document does not exist");
    }
  } catch (e) {
    print("Error fetching user type: $e");
  }
}