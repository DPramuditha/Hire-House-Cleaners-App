import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_cleaners_app/firebase/add_post.dart';
import 'package:lottie/lottie.dart';

class CleanersMessages extends StatefulWidget {
  const CleanersMessages({super.key});

  @override
  State<CleanersMessages> createState() => _CleanersMessagesState();
}

class _CleanersMessagesState extends State<CleanersMessages> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _AddCustomerPost = FirebaseFirestore.instance.collection("CustomerPosts");

  // Fetch only pending jobs
  Stream<List<AddPost>> getPendingCustomerPosts() {
    return _AddCustomerPost
        .where('status', isEqualTo: "Pending") // Filter only pending jobs
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AddPost.fromJson(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Pending Jobs",style: GoogleFonts.rubik(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: Color(0xff503cb7),
        centerTitle: true,
      ),
      body: StreamBuilder<List<AddPost>>(
        stream: getPendingCustomerPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Lottie.asset("assets_animation/planet.json", height: 250)); // Loading animation
          } else if (snapshot.hasError) {
            return Center(child: Text("Error Loading Posts"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Lottie.asset("assets_animation/planet.json", height: 250));
          } else {
            final List<AddPost> posts = snapshot.data!;
            return ListView.builder(
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
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            posts[index].title,
                            style: GoogleFonts.rubik(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          Text(
                            posts[index].description,
                            style: GoogleFonts.rubik(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Location: ${posts[index].location}",
                            style: GoogleFonts.rubik(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Type Of Floor: ${posts[index].typeOfFloor}",
                            style: GoogleFonts.rubik(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Price: ${posts[index].price}",
                            style: GoogleFonts.rubik(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                      ElevatedButton.icon(
                    onPressed: () async {
                    User? user = _auth.currentUser;
                  if (user == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("⚠️ Please log in to apply for jobs.")),
                 );
                      return;
                      }

                  String cleanerEmail = user.email!;
                  String customerEmail = posts[index].email; 

                          try {
      
                      var jobQuery = await FirebaseFirestore.instance
                        .collection("CustomerPosts")
                          .where("email", isEqualTo: customerEmail) 
                        .where("status", isEqualTo: "Pending") 
                        .get();

                        if (jobQuery.docs.isNotEmpty) {
                          for (var doc in jobQuery.docs) {
                              await doc.reference.update({
                            "status": "Ongoing",
                            "assignedCleaner": cleanerEmail, // ✅ Assign cleaner to job
                          });
                          print("✅ Job ID: ${doc.id} updated for cleaner: $cleanerEmail");
                            }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("✅ Job applied successfully!"))
                           );
                            } else {
                        print("❌ No pending job found for this customer.");
                          ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("❌ No available jobs for this customer."))
        );
      }
    } catch (e) {
      print("❌ Error updating job: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to apply for the job."))
      );
    }
  },
  icon: const Icon(Icons.check, color: Colors.white),
  label: Text(
    "Apply",
    style: GoogleFonts.rubik(color: Colors.white),
  ),
  style: ElevatedButton.styleFrom(backgroundColor: Color(0xff5d59f2)),
),


                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
