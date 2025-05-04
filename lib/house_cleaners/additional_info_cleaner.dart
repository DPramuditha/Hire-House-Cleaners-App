import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_cleaners_app/firebase/firebase_service.dart';
import 'package:house_cleaners_app/house_cleaners/cleaners_home.dart';
import 'package:lottie/lottie.dart';

class AdditionalInfoCleaner extends StatefulWidget {
  const AdditionalInfoCleaner({super.key});

  @override
  State<AdditionalInfoCleaner> createState() => _AdditionalInfoCleanerState();
}

class _AdditionalInfoCleanerState extends State<AdditionalInfoCleaner> {

  final _formkey = GlobalKey<FormState>();

  TextEditingController _contactNumber = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _yearsOfExperience = TextEditingController();
  TextEditingController _availabilityDays = TextEditingController();
  TextEditingController _certificationsTraining = TextEditingController();

  bool isLoading = false;
  Future addCleanerInformation() async {
    if(!_formkey.currentState!.validate()){
      return;

    }
    setState(() {
      isLoading = true;
    });
    try{
      final contactNumber = _contactNumber.text;
      final address = _address.text;
      final yearsOfExperience = _yearsOfExperience.text;
      final availabilityDays = _availabilityDays.text;
      final certifications = _certificationsTraining.text;

      User? user = FirebaseAuth.instance.currentUser;

      await FirebaseService().AddCleanerInfomation(contactNumber, address, yearsOfExperience, availabilityDays, certifications, user!.email!);
      print("✅ Cleaner Information added successfully");
      showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            title: Text("Cleaner Information Added Successfully", style: GoogleFonts.rubik(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("OK", style: GoogleFonts.rubik(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),))
            ],
          );
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CleanersHome()));

    }
    catch(e){
      print("😡Failed to add Cleaner Information $e");
      showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            title: Text("Failed to add Cleaner Information", style: GoogleFonts.rubik(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("OK", style: GoogleFonts.rubik(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),))
            ],
          );
        });
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Lottie.asset("assets_animation/cleaner.json"),
            SizedBox(
              height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                  children: [
                    Text("Additional Information", style: GoogleFonts.rubik(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),),
                    TextFormField(
                      controller: _contactNumber,
                      decoration: InputDecoration(
                        labelText: "Contact Number",
                        hintText: "Enter your contact number",
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your contact number";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _address,
                      decoration: InputDecoration(
                        labelText: "Your Address",
                        hintText: "Enter Your Address",
                        prefixIcon: Icon(Icons.location_on),
                        border:OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your address";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _yearsOfExperience,
                      decoration: InputDecoration(
                        labelText: "Years of Experience",
                        hintText: "Enter your years of experience",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.work),
                      ),
                      validator:(value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your years of experience";
                        }
                        return null;
                      } ,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _availabilityDays,
                      decoration: InputDecoration(
                        labelText: "Availability Days (Weekdays/Weekends)",
                        hintText: "Enter your availability days",
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your availability days";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _certificationsTraining,
                      decoration: InputDecoration(
                        labelText: "Certifications & Training",
                        hintText: "Enter your certifications & training (yes/no)",
                        prefixIcon: Icon(Icons.school),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your certifications & training";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ElevatedButton.icon(
                    onPressed: () async{
                      try{
                        await addCleanerInformation();
                        
                      }
                      catch(e){
                        print("😡Failed to add House Information $e");
                      }
                    if(_formkey.currentState!.validate()){
                      print("🚀Uploading Cleaner Information");
                      print("Contact Number: ${_contactNumber.text}");
                      print("Address: ${_address.text}"); 
                      print("Years of Experience: ${_yearsOfExperience.text}");
                      print("Availability Days: ${_availabilityDays.text}");
                      print("Certifications & Training: ${_certificationsTraining.text}");

                    }
                    else{
                      print("😡Validation Failed");
                    }
                    
                  }, icon: Icon(Icons.upload, color: Colors.white,),
                  label: Text("Upload Cleaner Information",style: GoogleFonts.rubik(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff503cb7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 20,
                    ),
                  ),
                  ElevatedButton.icon(onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CleanersHome()));

                  }, icon: Icon(Icons.arrow_circle_right_outlined,color: Colors.white,),
                  label: Text("Already filled this form",style: GoogleFonts.rubik(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff503cb7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 20,
                  )
                  ),
                    
                  ],
                ),),
              ),
          ],
        ),
      ),
    );
  }
}