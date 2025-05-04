import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_cleaners_app/customer/customer_home/customer_massage.dart';
import 'package:house_cleaners_app/customer/signin.dart';
import 'package:house_cleaners_app/firebase/add_post.dart';
import 'package:house_cleaners_app/firebase/firebase_service.dart';
import 'package:house_cleaners_app/firebase/login_user.dart';
import 'package:house_cleaners_app/house_cleaners/chat_screen.dart';
import 'package:house_cleaners_app/house_cleaners/cleaners_messages.dart';
import 'package:house_cleaners_app/house_cleaners/cleaners_profile.dart';

import 'package:lottie/lottie.dart';

class CleanersDashboard extends StatefulWidget {
  const CleanersDashboard({super.key});

  @override
  State<CleanersDashboard> createState() => _CleanersDashboardState();
}

class _CleanersDashboardState extends State<CleanersDashboard> {

 Future<void> updateJobStatus(String customerEmail, String cleanerEmail) async {
  try {
    var jobQuery = await FirebaseFirestore.instance
        .collection("CustomerPosts")
        .where("email", isEqualTo: customerEmail) // Match customer's job post
        .get();

    if (jobQuery.docs.isNotEmpty) {
      for (var doc in jobQuery.docs) {
        await doc.reference.update({"status": "Ongoing", "assignedCleaner": cleanerEmail});
      }
      print("✅ Job status updated to Ongoing for $cleanerEmail");
    } else {
      print("❌ No job found for this customer.");
    }
  } catch (e) {
    print("❌ Error updating job status: $e");
  }
}







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

    String? cleanerEmail;
  bool isLoading = true;

  // Get current logged-in cleaner's email
  void getCleanerInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        cleanerEmail = user.email;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("$fullName", style: GoogleFonts.rubik(
              fontWeight: FontWeight.bold,
            ),),
            Text("$email", style: GoogleFonts.rubik(
              fontSize: 15,
            ),),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xffffa633),
            ),
            child: IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> CleanersProfile()));
            }, icon: Icon(Icons.person),),
          ),
        ),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> CleanersMessages()));
            
          }, icon: Icon(Icons.notifications_none)),
          IconButton(onPressed: (){
            LoginUser().Logoutuser();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SigninPage()));
            
          }, icon: Icon(Icons.logout)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lottie Animation
            Lottie.asset(
              "assets_animation/cleaner_home.json",
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),

            // Review Section
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Review And Rating",
                textAlign: TextAlign.start,
                style: GoogleFonts.rubik(fontSize: 27, fontWeight: FontWeight.bold),
              ),
            ),

            // Horizontal Scroll Reviews
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // reviewCard("4.5", "Cleaner was very satisfied with the cleaning service. Professional, thorough, and punctual. Would highly recommend!", "John Smith"),
                  // reviewCard("4.8", "Great service! The cleaner was on time and very efficient. Will definitely book again.", "Emily Davis"),

              SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("CustomerFeedback")
            .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email!)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Lottie.asset("assets_animation/planet.json", height: 200));
          }

          if (snapshot.hasError) {
            return Center(child: Text("❌ Error loading reviews"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("⚠️ No reviews found."));
          }

          var reviews = snapshot.data!.docs;

          return Row(
            children: reviews.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  color: Color(0xff503cb7),
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Container(
                  width: 300,
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Row(
                      children: [
                      Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 4),
                        Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade700,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          data['rating']?.toString() ?? "Rating : 4.0", 
                          style: GoogleFonts.rubik(
                          color: Colors.white, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 16,
                          letterSpacing: 0.5,
                          ),
                        ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(data['review'] ?? "No review text",
                       style: GoogleFonts.rubik(color: Colors.white, fontSize: 14),
                       maxLines: 3,
                       overflow: TextOverflow.ellipsis),
                    SizedBox(height: 12),
                    Text("From: ${data['currentUser'] ?? "Unknown"}",
                       style: GoogleFonts.rubik(color: Colors.white70, fontStyle: FontStyle.italic)),
                    Text("Date: ${data['date']?.toDate()?.toString()?.substring(0, 10) ?? "N/A"}",
                       style: GoogleFonts.rubik(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    ],
  ),
)



//           StreamBuilder<QuerySnapshot>(
//   stream: FirebaseFirestore.instance
//       .collection("CustomerFeedback")
//       .where("currentUser", isEqualTo: cleanerEmail)
//       .snapshots(),
//   builder: (context, snapshot) {
//     if (snapshot.connectionState == ConnectionState.waiting) {
//       return Center(child: Lottie.asset("assets_animation/planet.json",height: 200));
//     }

//     if (snapshot.hasError) {
//       return Center(child: Text("❌ Error loading reviews"));
//     }

//     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//       return Center(child: Text("No reviews found."));
//     }

//     var reviews = snapshot.data!.docs;

//     return Row(
//       children: reviews.map((doc) {
//         var data = doc.data() as Map<String, dynamic>;

//         return reviewCard(
//           "4.0", // Default rating (can be changed if stored in Firestore)
//           data['review'] ?? "No review text",
//           data['email'] ?? "Unknown",
//         );
//       }).toList(),
//     );
//   },
// )
                ],
              ),
            ),

            SizedBox(height: 20),

          
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Recent Jobs",
                textAlign: TextAlign.start,
                style: GoogleFonts.rubik(fontSize: 27, fontWeight: FontWeight.bold),
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xff503cb7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Search Jobs",
                    hintStyle: GoogleFonts.rubik(color: Colors.white),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  style: GoogleFonts.rubik(color: Colors.white),
                ),
              ),
            ),

            SizedBox(height: 20),

            // StreamBuilder to Fetch Jobs
            StreamBuilder<List<AddPost>>(
              stream: FirebaseService().getCustomerPost(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Lottie.asset("assets_animation/planet.json",height: 250));
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error Loading Posts"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No Posts Found"));
                } else {
                  final List<AddPost> posts = snapshot.data!;
                  return SizedBox(
                    height: 400, 
                    child: ListView.builder(
                      itemCount: posts.length,
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
                                Text(posts[index].title, 
                                style: GoogleFonts.rubik(
                                  fontSize: 25,
                                
                                  fontWeight: FontWeight.bold), 
                                  maxLines: 2, 
                                  overflow: TextOverflow.ellipsis
                                  ),
                                Text(posts[index].description,
                                style: GoogleFonts.rubik(
                                  fontSize: 15,
                                
                                  fontWeight: FontWeight.bold
                                ),
                                ),
                                Text("Location: ${posts[index].location}",
                                style: GoogleFonts.rubik(
                                  fontSize: 15,
                              
                                  fontWeight: FontWeight.bold
                                )
                                ),
                                Text("Type OF Floor: ${posts[index].typeOfFloor}",
                                style: GoogleFonts.rubik(
                                  fontSize: 15,
                                
                                  fontWeight: FontWeight.bold
                                ),
                                ),
                                Text("Price : ${posts[index].price}",
                                style: GoogleFonts.rubik(
                                  fontSize: 27,
                              
                                  fontWeight: FontWeight.bold
                                ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    
                                    ElevatedButton.icon(
                                    onPressed: () async {
                                      User? user = FirebaseAuth.instance.currentUser;
                                      if (user == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("⚠️ Please log in to apply for jobs.")),
                                  );
                                            return;
                                        }

                                      String cleanerEmail = user.email!; 
                                      String customerEmail = posts[index].email; 

                                      await updateJobStatus(customerEmail, cleanerEmail);

                                    },
                                      icon: Icon(Icons.check),
                                        label: Text(
                                        posts[index].status == "Pending" ? "Apply" : posts[index].status, 
                                        style: GoogleFonts.rubik(),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: posts[index].status == "Pending" ? Colors.green : Colors.grey, // Disable if already applied
                                            ),
                 
                                    ),
                                    SizedBox(width: 10),
                                    // ElevatedButton.icon(
                                    //   onPressed: () {
                                    //     // Message Button
                                    //   },
                                    //   icon: Icon(Icons.message),
                                    //   label: Text("Message", style: GoogleFonts.rubik()),
                                    // ),
                                    // SizedBox(width: 10),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                         Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CleanerChatScreen(customerEmail: posts[index].email),
      ),
    );
                                      },
                                      icon: Icon(Icons.mark_email_unread),
                                      label: Text("Message", style: GoogleFonts.rubik()),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Date: ${posts[index].timestamp.toString().substring(0, 10)}",
                                style: GoogleFonts.rubik(
                                  fontSize: 15,
                          
                                  fontWeight: FontWeight.bold
                                )
                                ),
                                Text("Time: ${posts[index].timestamp.toString().substring(11, 16)}",
                                style: GoogleFonts.rubik(
                                ),
                                ),
                              ],
                            ),
                          
                          
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget for Review Cards
  Widget reviewCard(String rating, String review, String reviewer) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Color(0xff503cb7),
        elevation: 20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Color(0xff503cb7),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Rating: $rating", style: GoogleFonts.rubik(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    Icon(Icons.star, color: Colors.yellow),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  review,
                  style: GoogleFonts.rubik(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "- $reviewer",
                  style: GoogleFonts.rubik(fontSize: 14, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Job Cards
  Widget jobCard(String title) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Color(0xff503cb7),
        elevation: 20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          title: Text(
            title,
            style: GoogleFonts.rubik(color: Colors.white, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
