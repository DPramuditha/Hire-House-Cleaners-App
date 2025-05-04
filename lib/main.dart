import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:house_cleaners_app/customer/customer_home/customer_home_page.dart';
import 'package:house_cleaners_app/customer/pages_move.dart';
import 'package:house_cleaners_app/customer/register.dart';
import 'package:house_cleaners_app/customer/signin.dart';
import 'package:house_cleaners_app/firebase/firebase_service.dart';
import 'package:house_cleaners_app/welcome_page.dart';
import 'package:house_cleaners_app/house_cleaners/additional_info_cleaner.dart';
import 'package:house_cleaners_app/house_cleaners/cleaners_dashboard.dart';
import 'package:house_cleaners_app/house_cleaners/cleaners_home.dart';
import 'customer/customer_home/House_Information.dart';
main() async{
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // FirebaseService().FirebaseConnection();
    WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp();

    if(kIsWeb) {
      await Firebase.initializeApp(options: FirebaseOptions(
        apiKey: "",
        authDomain: "",
        projectId: "",
        storageBucket: "",
        messagingSenderId: "",
        appId: ""
      ));

    }else{
     await Firebase.initializeApp();
    }

  try {
    await Firebase.initializeApp();
    print("✅Firebase is connected successfully!");

  } catch (e) {
    print("❌Firebase connection failed: $e");
  }
  
  runApp(HouseCleaner());
}
class HouseCleaner extends StatelessWidget {
  const HouseCleaner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}
