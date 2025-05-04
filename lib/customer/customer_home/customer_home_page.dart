import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_cleaners_app/chat_with_Cleaner.dart';
import 'package:house_cleaners_app/customer/customer_home/customer_massage.dart';
import 'package:house_cleaners_app/customer/customer_home/customer_profile.dart';
import 'package:house_cleaners_app/customer/customer_home/hire_cleaners.dart';
import 'package:house_cleaners_app/customer/signin.dart';
import 'package:house_cleaners_app/firebase/add_post.dart';
import 'package:house_cleaners_app/firebase/firebase_service.dart';
import 'package:house_cleaners_app/firebase/login_user.dart';
import 'package:house_cleaners_app/firebase/register.dart';
import 'package:lottie/lottie.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {

  List<Map<String, String>> cleanCetgory = [
    {"image": "assets/deep.jpg", "label": "House Cleaning"},
    {"image": "assets/carpet.jpg", "label": "Carpet Cleaning"},
    {"image": "assets/kitchen.jpg", "label": "Kitchen Cleaning"},
    {"image": "assets/bathroom.jpg", "label": "Bathroom Cleaning"},
    {"image": "assets/living.jpg", "label": "Living Areas"},




  ];

  Future<void> deletePostByEmail(String userEmail) async {
  try {
    print("🔍 Searching for posts with email: $userEmail");

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("CustomerPosts")
        .where("email", isEqualTo: userEmail) // Match customer email
        .get();

    if (querySnapshot.docs.isEmpty) {
      print("❌ No post found for email: $userEmail");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ No post found for your email.")),
      );
      return;
    }

    // Delete all matching posts
    for (var doc in querySnapshot.docs) {
      print("🗑️ Deleting post with ID: ${doc.id}");
      await FirebaseFirestore.instance.collection("CustomerPosts").doc(doc.id).delete();
    }

    print("✅ Post(s) deleted successfully!");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Post deleted successfully!")),
    );
  } catch (e) {
    print("❌ Error deleting post: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Error deleting post: $e")),
    );
  }
}

  

  // Deep Cleaning

  String fullName = "Loading...";
  String email = "Not logged in";

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void getUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser; 
    if (user != null) {
      String userEmail = user.email!; 

      var snapshot = await FirebaseFirestore.instance
          .collection('RegisterCustomer')
          .where('email', isEqualTo: userEmail) 
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          fullName = snapshot.docs[0]['fullName']; 
          email = userEmail; 
        });
      } else {
        setState(() {
          fullName = "No name found";
          email = userEmail;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {

    StreamBuilder(
  stream: FirebaseService().getRegisterCustomer(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } 
    else if (snapshot.hasError) {
      return Center(child: Text("Error Loading Customers"));
    } 
    else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Center(child: Text("No Customers Found"));
    } 
    else {
      List<Register> customers = snapshot.data!;

      return ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index) {
          var customer = customers[index];

          return Card(
            margin: EdgeInsets.all(10),
            elevation: 3,
            child: ListTile(
              title: Text(customer.fullName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Email: ${customer.fullName}"),
                  Text("Phone: ${customer.phoneNumber}"),
                  Text("User Type: ${customer.userType}"),
                ],
              ),
              leading: Icon(Icons.person),
            ),
          );
        },
      );
    }
  },
);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$fullName",style: GoogleFonts.rubik(
              fontWeight: FontWeight.bold,
            ),),
            Text("$email",style: TextStyle(
              fontSize: 15,
            ),)
          ],
        ),

        leading: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.yellow,
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey,
                //     blurRadius: 10,
                //     spreadRadius: 1,
                //   ),
                // ]
              ),
              child: IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerProfile()));

              }, icon: Icon(Icons.person_pin_rounded),
              )
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              width: 50,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xffffa633),
              ),
              child: IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerMassage()));
              }, icon: Icon(Icons.notifications_active_rounded),
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              width: 50,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xffffa633),
              ),
              child: IconButton(onPressed: (){
                LoginUser().Logoutuser();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SigninPage()));
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerProfile()));

              }, icon: Icon(Icons.logout_rounded, color: Colors.black,),
              )
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Lottie.asset("assets_animation/choose.json",
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            // Lottie.network("https://lottie.host/951b702b-8d0c-440c-a94a-3e432d769135/6gN2OApjNb.json",
            //   Image(image: AssetImage("assets/homemain.jpg"),
            //   width: double.infinity,
            //   fit: BoxFit.cover,
            // ),
            Center(
              child: Text("Book Professional Cleaners In Minutes",
                textAlign: TextAlign.center,
                style: GoogleFonts.rubik(
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
              ),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:cleanCetgory.map((option){
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            image: DecorationImage(
                              image: AssetImage(option["image"]!),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(option["label"]!,style: GoogleFonts.rubik(
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),

            Text("Select Your Service",style: GoogleFonts.rubik(
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 200,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(colors: [Color(0xffff00ff),Color(0xffc700c7),Color(0xff990099),Color(0xff660066),]),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Container(
                                child: Image(image: AssetImage("assets/gernaral.jpg"),
                                  width: double.infinity,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text("General Cleaning",style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),),
                              Text("Dusting, vacuuming, mopping, and wiping surfaces.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                fontSize: 15,
                              ),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 200,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(colors: [Color(0xffff00ff),Color(0xffc700c7),Color(0xff990099),Color(0xff660066),]),
                          boxShadow: [
                            
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Image(image: AssetImage("assets/kitchen.jpg"),
                                width: double.infinity,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              Text("Kitchen Cleaning",style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),),
                              Text("Cleaning countertops, sinks, appliances (exterior), and taking out the trash.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                fontSize: 15,
                              ),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 200,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(colors: [Color(0xffff00ff),Color(0xffc700c7),Color(0xff990099),Color(0xff660066),]),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Image(image: AssetImage("assets/bathroom.jpg"),
                                width: double.infinity,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              Text("Bathroom Cleaning",style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),),
                              Text("Cleaning showers, bathtubs, toilets, and sinks.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                fontSize: 15,
                              ),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 200,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(colors: [Color(0xffff00ff),Color(0xffc700c7),Color(0xff990099),Color(0xff660066),]),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Image(image: AssetImage("assets/living.jpg"),
                                width: double.infinity,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              Text("Living Areas",style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),),
                              Text("Dusting, vacuuming, mopping, and wiping surfaces.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                fontSize: 15,
                              ),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 200,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(colors: [Color(0xffff00ff),Color(0xffc700c7),Color(0xff990099),Color(0xff660066),]),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Image(image: AssetImage("assets/deep.jpg"),
                                width: double.infinity,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              Text("Deep Cleaning",style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),),
                              Text("Cleaning all surfaces, appliances, and floors.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                fontSize: 15,
                              ),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Text("Add hire cleaners",style: GoogleFonts.rubik(
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),),

    StreamBuilder<List<AddPost>>(
  stream: FirebaseService().getCustomerPost(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: Lottie.asset("assets_animation/planet.json", height: 250));
    } else if (snapshot.hasError) {
      return Center(child: Text("Error Loading Posts"));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Center(child: Text("No Posts Found"));
    } else {

      String currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? "";

      final List<AddPost> userPosts = snapshot.data!.where((post) => post.email == currentUserEmail).toList();

      if (userPosts.isEmpty) {
        return Center(child: Text("No Posts Found for You"));
      }

      return SizedBox(
        height: 400,
        child: ListView.builder(
          itemCount: userPosts.length,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                color: Color(0xffe6d600),
                elevation: 20,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Text(userPosts[index].title,
                        style: GoogleFonts.rubik(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    Text(userPosts[index].description,
                        style: GoogleFonts.rubik(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                    Text("Location: ${userPosts[index].location}",
                        style: GoogleFonts.rubik(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                    Text("Type Of Floor: ${userPosts[index].typeOfFloor}",
                        style: GoogleFonts.rubik(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                    Text("Price: ${userPosts[index].price}",
                        style: GoogleFonts.rubik(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen(cleanerEmail: userPosts[index].assignedCleaner))
              );
                            // Apply Function
                          },
                          icon: Icon(Icons.mark_email_unread_rounded),
                          label: Text("Massage", style: GoogleFonts.rubik()),
                        ),
                        SizedBox(width: 10),

  ElevatedButton.icon(
  onPressed: () async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please log in to delete your post.")),
      );
      return;
    }

    String userEmail = user.email!;
    await deletePostByEmail(userEmail); // Call the delete function
  },
  icon: Icon(Icons.delete_forever_rounded, color: Colors.white),
  label: Text("Delete", style: GoogleFonts.rubik()),
  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text("Date: ${userPosts[index].timestamp.toString().substring(0, 10)}",
                        style: GoogleFonts.rubik(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                    Text("Time: ${userPosts[index].timestamp.toString().substring(11, 16)}",
                        style: GoogleFonts.rubik()),

                    Text("Status: ${userPosts[index].status}",
                        style: GoogleFonts.rubik(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                    Text("Assigned Cleaner: ${userPosts[index].assignedCleaner}",
                        style: GoogleFonts.rubik(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  },
)

       ]
      ),
     ),
    );
  }
}
