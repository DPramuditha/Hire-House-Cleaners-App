import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_cleaners_app/customer/signin.dart';
import 'package:house_cleaners_app/firebase/firebase_service.dart';
import 'package:house_cleaners_app/firebase/login_user.dart';
import 'package:lottie/lottie.dart';

class RegisterCustomer extends StatefulWidget {
  const RegisterCustomer({super.key});

  @override
  State<RegisterCustomer> createState() => _RegisterCustomerState();
}

class _RegisterCustomerState extends State<RegisterCustomer> {

  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _userTypesController = TextEditingController();


  final _formkey = GlobalKey<FormState>();

  bool isLoading = false;
  Future<void> RegisterUser() async{
    if(!_formkey.currentState!.validate()){
      return;
    }
    setState(() {
      isLoading = true;
    });
    try{
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      await LoginUser().Registeruser(email: email, password: password);
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SigninPage()));
        showDialog(
          context: context, 
          builder: (context){
            return AlertDialog(
              title: Text("Success"),
              content: Text("User Registered Successfully"),

              actions: [
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text("Ok"))
              ],
            );
          });

    }
    catch(e){
      print("Error: $e");
      showDialog(
        context: context, 
      builder: (context){
        return AlertDialog(
          title: Text("Error"),
          content: Text("Failed to Register User"),

          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("Ok"))
          ],
        );
      });
    }
    finally{
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
              child: Lottie.asset("assets_animation/Signin.json",
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              // child: Lottie.network("https://lottie.host/bae36120-5db9-483f-8ee8-729a5f6039cb/jUyBAbgL4m.json",
              //    child: Image(image: AssetImage("assets/register.jpg"),
              //   width: double.infinity,
              //   // height: 400,
              //   fit: BoxFit.cover,
              // ),
            ),
            SizedBox(
              height: 20,
            ),
            Form(
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                children: [
                  TextFormField(
                    controller: _fullnameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      hintText: "Enter Your Name",
                      hintStyle: TextStyle(
                        fontSize: 20,
                      ),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_rounded),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please Enter Your Name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter Your Email address",
                      hintStyle: TextStyle(
                        fontSize: 20,
                      ),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
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
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter Your Password",
                      hintStyle: TextStyle(
                        fontSize: 20,
                      ),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
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
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      hintText: "Enter Your Phone Number",
                      hintStyle: TextStyle(
                        fontSize: 20,
                      ),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please Enter Your Phone Number";
                      }
                      else if(value.length < 10){
                        return "Phone Number must be at least 10 characters";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _userTypesController,
                    decoration: InputDecoration(
                      labelText: "User Type Customer Or Cleaner",
                      hintText: "Select User Type",
                      hintStyle: TextStyle(
                        fontSize: 20,
                      ),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please Select User Type";
                      }
                      return null;
                    },

                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(colors: [Color(0xffffc107),Color(0xffffc107),Color(0xffff9800)]),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 20,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () async {
                        try{
                          await RegisterUser();

                          await FirebaseService().addCustomer(_fullnameController.text, _emailController.text,_passwordController.text, _phoneNumberController.text, _userTypesController.text, DateTime.now());

                          print("🫡User Registered Successfully");
                        }
                        catch(e){

                          print("User Register some Error😡 $e");
                        }

 
                        
                        if(_formkey.currentState!.validate()){
                          print("Full Name: ${_fullnameController.text}");

                          print("Email: ${_emailController.text}");
                        }
                        else{
                          print("Please Enter Valid Data");
                        }
                      },
                      child: Text(
                        "Register",
                        style: GoogleFonts.rubik(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                 SizedBox(
                   height: 20,
                 ),
                 Text("Already have an account?", style: GoogleFonts.rubik(
                 fontSize: 17,
                 ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(onPressed: (){
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => SigninPage()));
                  },icon: Icon(Icons.account_box_rounded),
                    label: Text("Login Here", style: GoogleFonts.rubik(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
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
