import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_cleaners_app/customer/customer_home/House_Information.dart';
import 'package:house_cleaners_app/customer/customer_home/customer_home_page.dart';
import 'package:house_cleaners_app/customer/pages_move.dart';
import 'package:house_cleaners_app/customer/register.dart';
import 'package:house_cleaners_app/firebase/firebase_service.dart';
import 'package:house_cleaners_app/firebase/login_user.dart';
import 'package:house_cleaners_app/house_cleaners/additional_info_cleaner.dart';
import 'package:house_cleaners_app/house_cleaners/cleaners_dashboard.dart';
import 'package:house_cleaners_app/house_cleaners/cleaners_home.dart';
import 'package:lottie/lottie.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> SignInUser()async{
    if(!_formkey.currentState!.validate()){
      return;
    }
    setState(() {
      isLoading = true;
    });



 Future<void> checkUserTypeAndNavigate(BuildContext context, String email) async {
  try {
    // Query Firestore collection "RegisterCustomer" for the user with the given email
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("RegisterCustomer")
        .where("email", isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var userDoc = querySnapshot.docs.first; // Get the first matched document
      String userType = userDoc["userType"].trim(); // Trim whitespace if any

      if (userType == "Customer") {
        print("User is a Customer☺️");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HouseInformation()),
        );
      } else if (userType == "Cleaner") {
        print("User is a Cleaner😏");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdditionalInfoCleaner()),
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
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } else {
      print("❓User not found in Firestore");
    }
  } catch (e) {
    print("❓Error fetching user type: $e");
  }
}

    try{
      final email = _emailController.text.trim();
      final password = _passwordcontroller.text.trim();

      await LoginUser().Loginuser(email: email, password: password);
      await checkUserTypeAndNavigate(context, email);
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HouseInformation()));
      showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            title: Text("Success"),
            content: Text("User Logged in Successfully"),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("OK"))
            ],
          );
        }
      );
      

    }
    catch(e){
      print(e);
      showDialog(
        context: context, 
      builder: (context){
        return AlertDialog(
          title: Text("Error"),
          content: Text("Failed to Login User"),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("OK"))
          ],
        );
      });
    }

  // try {
  //   final email = _emailController.text.trim();
  //   final password = _passwordcontroller.text.trim();

  //   await LoginUser().Loginuser(email: email, password: password);

  //   // Check user type and navigate accordingly
  //   await LoginUser().checkUserTypeAndNavigate(context, email);
  // } catch (e) {
  //   print("Error: $e");
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text("Error"),
  //         content: Text("Failed to Login"),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: Text("Ok"),
  //           )
  //         ],
  //       );
  //     },
  //   );
  // } finally {
  //   setState(() {
  //     isLoading = false;
  //   });
  // }
  }


    // Future<void> _signWithGoogle() async { 
    //   setState(() {
    //     isLoading = true;
    //   }); 

    //   try{
    //     await FirebaseService().signInWithGoogle();
    //     print("✅ Google sign in successful! ɢ");
    //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CleanersDashboard()));
        

    //   }
    //   catch
    //   (e){
    //     print("❌ Error signing in with Google: $e");
    //     showDialog(
    //       context: context, 
    //       builder: (context){
    //         return AlertDialog(
    //           title: Text("Error"),
    //           content: Text("Failed to Sign in with Google"),
    //           actions: [
    //             TextButton(onPressed: (){
    //               Navigator.pop(context);
    //             }, child: Text("OK"))
    //           ],
    //         );
    //       });
    //   }
    //   finally{
    //     setState(() {
    //       isLoading = false;
    //     });
    //   }
    // }

  Future<void> _signWithGoogle() async { 
  setState(() {
    isLoading = true;
  }); 

  try {
    final UserCredential? userCredential = await FirebaseService().signInWithGoogle();

    if (userCredential == null) {
      print("❌ Google sign-in canceled or failed.");
      return; // Exit the function without navigating
    }

    print("✅ Google sign-in successful! ɢ");
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => CustomerHomePage()),
    );

  } catch (e) {
    print("❌ Error signing in with Google: $e");
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Failed to Sign in with Google"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              }, 
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}




 



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Lottie.asset("assets_animation/register.json",
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // child: Lottie.network("https://lottie.host/8f4b0c84-e570-4c37-950f-62eb40c8cac1/IAVS7hDyD6.json",
                //   child: Image(image: AssetImage("assets/signup.jpg"),
                //   width: double.infinity,
                //   // height: 400,
                //   fit: BoxFit.cover,
                // ),
              ),
              // child: Image(image: AssetImage("assets/signup.jpg"),
              //   width: double.infinity,
              //   height: 500,
              //   fit: BoxFit.cover,
              // ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  // gradient: LinearGradient(colors: [Color(0xff1717cf),Color(0xff2b2bff),Color(0xff5656ff),Color(0xff),]),
                ),
                child: Column(
                  children: [
                    Form(
                      key: _formkey,
                      child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            hintText: "Enter Your Email",
                            hintStyle: TextStyle(
                              fontSize: 20,
                            ),
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return "Please Enter Your Email";
                            }
                            else if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                              return "Please Enter a valid Email";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _passwordcontroller,
                          cursorWidth: 2,
                          decoration: InputDecoration(
                            labelText: "Password",
                            hintText: "Enter Your Password",
                            hintStyle: TextStyle(
                              fontSize: 20,
                            ),
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return "Please Enter Your Password";
                            }
                            else if(value.length < 6){
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                          obscureText: true,
                        ),

                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(colors: [Color(0xff503cb7), Color(0xff422ea8), Color(0xff4733ea), Color(0xff4a3de0),]),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 20,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: TextButton(onPressed: (){
                              SignInUser();
                                if(_formkey.currentState!.validate()){
                                  print("Email: ${_emailController.text}");
                                  print("Password: ${_passwordcontroller.text}");
                                }
                                else{
                                  print("Form is Invalid");
                                }
                            }, child: Text("Login",style: GoogleFonts.rubik(
                              fontSize: 23,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                            ),
                          ),
                        ),
                        Text("Don't have an account?" , style: GoogleFonts.rubik(
                          fontSize: 17,
                        ),),
                        TextButton(onPressed: (){
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => RegisterCustomer()));
                        }, child: Text("Create an Account", style: TextStyle(
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                        ),)),
                        Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [Color(0xffff8500),Color(0xffff6e00),Color(0xffff5700)]),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 15,
                                  spreadRadius: 1,

                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset("assets_animation/google.json",
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                ),
                                TextButton(onPressed: (){
                                  _signWithGoogle();

                                }, child: Text("Sign in With Google", style: GoogleFonts.rubik(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
