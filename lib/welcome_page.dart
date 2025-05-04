import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_cleaners_app/customer/signin.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Lottie.asset("assets_animation/welcome.json", 
          height: 315,
          fit: BoxFit.cover,
          ),
          SizedBox(
            height: 25,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xff503cb7), Color(0xff503cb7)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(1, 3),
                )
              ]
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                  "Welcome to House Cleaners",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  ),
                  ),
                  SizedBox(height: 15),
                  Text(
                  "Get your house cleaned by professionals",
                  style: GoogleFonts.rubik(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Text(
                  "Your one-stop solution for reliable and efficient home cleaning services. Book skilled cleaners, customize your cleaning needs, and enjoy a spotless home without any hassle.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(
                  fontSize: 14,
                  color: Colors.white70,
                  ),
                  ),
                  ),
                  SizedBox(height: 30),
                  FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SigninPage()));
                    print("Welcome to House Cleaners☺️");
                  },
                  label: Text('Get Started',
                    style: GoogleFonts.rubik(
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: Icon(Icons.arrow_forward),
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xff503cb7),
                  elevation: 8,
                  ),
                  SizedBox(height: 20),
                  
                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}