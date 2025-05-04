import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_cleaners_app/customer/customer_home/House_Information.dart';
import 'package:house_cleaners_app/customer/signin.dart';
import 'package:house_cleaners_app/firebase/add_house_info.dart';
import 'package:house_cleaners_app/firebase/firebase_service.dart';
import 'package:lottie/lottie.dart';

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({super.key});

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {

  
  // String fullName = "Loading...";
  // String email = "Not logged in";

  // @override
  // void initState() {
  //   super.initState();
  //   getUserInfo();
  // }

  // void getUserInfo() async {
  //   User? user = FirebaseAuth.instance.currentUser; 
  //   if (user != null) {
  //     String userEmail = user.email!; 

  //     var snapshot = await FirebaseFirestore.instance
  //         .collection('RegisterCustomer')
  //         .where('email', isEqualTo: userEmail) 
  //         .get();

  //     if (snapshot.docs.isNotEmpty) {
  //       setState(() {
  //         fullName = snapshot.docs[0]['fullName']; 
  //         email = userEmail; 
  //       });
  //     } else {
  //       setState(() {
  //         fullName = "No name found";
  //         email = userEmail;
  //       });
  //     }
  //   }
  // }

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
        title: Center(child:
        Text("Customer Profile", style: GoogleFonts.rubik(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xff), Color(0xff)]
            ),
          ),
        ),
        
      ),
      
      body: SingleChildScrollView(
        child: isLoading ? Center(child: Lottie.asset("assets_animation/planet.json",height: 250,)) 
          : Column(
            children: [
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // image: DecorationImage(
                    //   image: AssetImage("assets/signup.jpg"),
                    //   fit: BoxFit.fill,
                    // ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.10),
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ], 
                  ),
                  child: Lottie.asset("assets_animation/profile.json",
                  width:200,
                  height: 200,
                  fit: BoxFit.fill,
                  ),
                ),
              ),
              Text("$fullName", style: GoogleFonts.rubik(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),),
          
              Text("$email", style: GoogleFonts.rubik(
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
              Column(
                children: [
                  Row(
                    children: [
                      Lottie.asset("assets_animation/house.json", width: 100, height: 100,),
                      Text("My House Informantion", style: GoogleFonts.rubik(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),),
                      SizedBox(width: 10,),
                    ],
                  
                  ),
StreamBuilder(
  stream: FirebaseService().getHouseInformation(FirebaseAuth.instance.currentUser!.email!), 
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: Lottie.asset("assets_animation/planet.json", height: 250));
    } else if (snapshot.hasError) {
      return Center(child: Text("Error: ${snapshot.error}"));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Center(child: Text("⚠️ No house information found!")); 
    } else {
      final List<AddHouseInfo> houseInformation = snapshot.data!;
      
      print("✅ Fetched houses: ${houseInformation.length}");

      return ListView.builder(
        shrinkWrap: true,
        itemCount: houseInformation.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 10,
              child: ListTile(
                leading: Icon(Icons.home),
                title: Text(
                  houseInformation[index].houseAddress,
                  style: GoogleFonts.rubik(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                subtitle: Text(
                  "Number of Rooms: ${houseInformation[index].numberOfRoom} \n"
                  "Number of Bathrooms: ${houseInformation[index].numberOfBathroom} \n"
                  "Floor Type: ${houseInformation[index].floorType}",
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


              //   StreamBuilder(
              //     stream: FirebaseService().getHouseInformation(user!.email!), 
              //     builder:(context, snapshot){
              //       if(snapshot.connectionState == ConnectionState.waiting){
              //         return Center(child:Lottie.asset("assets_animation/planet.json",height: 250,));
              //       }
              //       else if(snapshot.hasError){
              //         return Center(child: Text("Error: ${snapshot.error}"),);
              //       }
              //       else if(!snapshot.hasData || snapshot.data!.isEmpty){
              //         return Center(child: Text("No data found!"),);
              //       }
              //       else{
              //         final List<AddHouseInfo> houseInformation = snapshot.data!;
              //         return ListView.builder(
              //           shrinkWrap: true,
              //           itemCount: houseInformation.length,
              //           itemBuilder: (context, index){
              //             return Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Card(
              //                 elevation: 10,
              //                 child: ListTile(
              //                   leading: Icon(Icons.home),
              //                   title: Text(houseInformation[index].houseAddress, style: GoogleFonts.rubik(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 20,
              //                   ),),
              //                   subtitle: Text("Number of Room: ${houseInformation[index].numberOfRoom} \n Number of Bathroom: ${houseInformation[index].numberOfBathroom} \nFloor Type: ${houseInformation[index].floorType}"),
              //                   trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue,),
              //                   onTap: (){
              //                     // Navigator.push(context, MaterialPageRoute(builder: (context) => HouseInformation(houseInformation: houseInformation[index],)));
              //                   },
              //                 ),
              //               ),
              //             );
              //           },
              //         );
              //       }
              //     })
              //   ],
              // ),
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
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                          color: Colors.blue,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.notifications),
                        title: Text("Notifications", style: GoogleFonts.rubik(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        ),
                        onTap: (){

                        },
                        trailing: Icon(Icons.arrow_forward_ios,
                          color: Colors.blue,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text("Settings", style: GoogleFonts.rubik(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        ),
                        onTap: (){
                          
                        },
                        trailing: Icon(Icons.arrow_forward_ios,
                          color: Colors.blue,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text("Logout", style: GoogleFonts.rubik(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        ),
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SigninPage()));
                        },
                        trailing: Icon(Icons.arrow_forward_ios,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
            ]
          )
      ),
    );
  }
}
