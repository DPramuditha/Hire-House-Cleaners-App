import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_cleaners_app/customer/signin.dart';
import 'package:house_cleaners_app/firebase/add_house_info.dart';
import 'package:house_cleaners_app/firebase/cleaner_infomation.dart';
import 'package:house_cleaners_app/firebase/firebase_service.dart';
import 'package:house_cleaners_app/house_cleaners/additional_info_cleaner.dart';
import 'package:lottie/lottie.dart';

class CleanersProfile extends StatefulWidget {
  const CleanersProfile({super.key});

  @override
  State<CleanersProfile> createState() => _CleanersProfileState();
}

class _CleanersProfileState extends State<CleanersProfile> {

  String? fullName;
  String? email;
  bool isLoading = true; 

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void getUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser; // Get logged-in user
    if (user != null) {
      String userEmail = user.email!; // Retrieve email from FirebaseAuth

      var snapshot = await FirebaseFirestore.instance
          .collection('RegisterCustomer')
          .where('email', isEqualTo: userEmail) // Filter by email
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          fullName = snapshot.docs[0]['fullName']; // Fetch full name
          email = userEmail; // Store email
          isLoading = false; // Stop loading
        });
      } else {
        setState(() {
          fullName = "No name found";
          email = userEmail;
          isLoading = false;
        });
      }
    } else {
      setState(() {
        fullName = "Not logged in";
        email = "No email";
        isLoading = false;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
     final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Cleaners Profile",
          style: GoogleFonts.rubik(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          ),
        ),
      ),
      
      body: SingleChildScrollView(
        child: isLoading
            ? Center(child: Lottie.asset("assets_animation/planet.json", height: 250))
        : Column(
          children: [
            SizedBox(height: 20,),
            Center(
              child: Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, 
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ]
                ),
                child: Lottie.asset("assets_animation/cleaner_profile.json",
                width: 300,
                height: 200,
                fit: BoxFit.fill,
                ),
              
              ),
            ),
            Text("$fullName", style: GoogleFonts.rubik(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),),
            Text("$email",style: GoogleFonts.rubik(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),),
              SizedBox(
                  height: 10,
                  ),
                ElevatedButton.icon(onPressed:(){
            
                }, icon: Icon(Icons.edit),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellowAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 10,
                  ),
                label: Text("Edit Profile", style: GoogleFonts.rubik(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),),
                ),
                SizedBox(
                  height: 10,
                  ),
          Row(
            children: [
              Lottie.asset("assets_animation/cleaner.json",
                width: 100,
                height: 100,
              ),
              Text("My Information", style: GoogleFonts.rubik(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
            ],
          ),
          StreamBuilder(
  stream: FirebaseService().getCleanerInformation(FirebaseAuth.instance.currentUser!.email!), 
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text("Error: ${snapshot.error}"));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Center(child: Text("⚠️ No cleaner information found!")); 
    } else {
      final List<CleanerInfomation> cleanerInformation = snapshot.data!;
      
      print("✅ Cleaner details fetched: ${cleanerInformation.length}"); 

      return ListView.builder(
        shrinkWrap: true,
        itemCount: cleanerInformation.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 10,
              child: ListTile(
         
                title: Text(
                  "Contact Number: ${cleanerInformation[index].contactNumber}",
                  style: GoogleFonts.rubik(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text(
                  "Address: ${cleanerInformation[index].address} \n"
                  "Years of Experience: ${cleanerInformation[index].yearsOfExperience} \n"
                  "Availability Days: ${cleanerInformation[index].availabilityDays} \n"
                  "Certifications: ${cleanerInformation[index].certifications}",
                  style: GoogleFonts.rubik(fontSize: 14),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
              ),
            ),
          );
        },
      );
    }
  },
),

        //  StreamBuilder(
        //           stream: FirebaseService().getCleanerInformation(user!.email!), 
        //           builder:(context, snapshot){
        //             if(snapshot.connectionState == ConnectionState.waiting){
        //               return Center(child: CircularProgressIndicator(),);
        //             }
        //             else if(snapshot.hasError){
        //               return Center(child: Text("Error: ${snapshot.error}"),);
        //             }
        //             else if(!snapshot.hasData || snapshot.data!.isEmpty){
        //               return Center(child: Text("No data found!"),);
        //             }
        //             else{
        //               final List<CleanerInfomation> cleanerInfomation = snapshot.data!;
        //               return ListView.builder(
        //                 shrinkWrap: true,
        //                 itemCount: cleanerInfomation.length,
        //                 itemBuilder: (context, index){
        //                   return Padding(
        //                     padding: const EdgeInsets.all(8.0),
        //                     child: Card(
        //                       elevation: 10,
        //                       child: ListTile(
        //                         leading: Icon(Icons.home),
        //                         title: Text("Contact Number: ${cleanerInfomation[index].contactNumber}"),
        //                         subtitle: Text("Address: ${cleanerInfomation[index].address} \nYears of Experience: ${cleanerInfomation[index].yearsOfExperience} \nAvailability Days: ${cleanerInfomation[index].availabilityDays} \nCertifications: ${cleanerInfomation[index].certifications}"),
        //                         trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue,),
        //                         onTap: (){
        //                           // Navigator.push(context, MaterialPageRoute(builder: (context) => HouseInformation(houseInformation: houseInformation[index],)));
        //                         },
        //                       ),
        //                     ),
        //                   );
        //                 },
        //               );
        //             }
        //           }),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xffff00ff), Color(0xffc700c7),Color(0xff990099),Color(0xff660066)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.payment),
                      title: Text("Payment", style: GoogleFonts.rubik(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),),
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => Payment()));
                      },
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text("Settings", style: GoogleFonts.rubik(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),),
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
                      },
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text("Logout", style: GoogleFonts.rubik(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),),
                      onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SigninPage()));
                      },
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
            ),
          ),
          SizedBox(height: 30,),
          ],
        ),
      ),

    );
  }
}