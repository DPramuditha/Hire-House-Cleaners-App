import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_cleaners_app/customer/register.dart';
import 'package:house_cleaners_app/firebase/firebase_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class HireCleaners extends StatefulWidget {
  const HireCleaners({super.key});

  @override
  State<HireCleaners> createState() => _HireCleanersState();
}

class _HireCleanersState extends State<HireCleaners> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _typeOfFloorController = TextEditingController();
  TextEditingController _numberOfRoomsController = TextEditingController();
  TextEditingController _numberOfBathroomsController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

double calculateCleaningPrice(int rooms, int bathrooms, String cleaningType) {
  double basePrice = 1000;
  double roomRate = 500;
  double bathroomRate = 700;

  Map<String, double> cleaningMultipliers = {
    "Regular": 1.0,
    "Deep Cleaning": 1.5,
    "Move-out Cleaning": 2.0,
  };

  double price = basePrice + (roomRate * rooms) + (bathroomRate * bathrooms);
  price *= cleaningMultipliers[cleaningType] ?? 1.0; // Default to 1.0 if type not found

  return price;
}
  bool isLoading = false;
  // Future<void> addCleaningPost() async {
  //   if(!_formkey.currentState!.validate()){
  //       return;
  //   }
  //   setState(() {
  //     isLoading = true;
  //   });
  //     try {
  //       final title = _titleController.text;
  //       final location = _locationController.text;
  //       final typeOfFloor = _typeOfFloorController.text;
  //       final description = _descriptionController.text;
  //       final int numberOfRooms = int.tryParse(_numberOfRoomsController.text) ?? 0;
  //       final int numberOfBathrooms = int.tryParse(_numberOfBathroomsController.text) ?? 0;
  //       DateTime time = DateTime.now();

  //     User? user = FirebaseAuth.instance.currentUser;
      

  //       double price = calculateCleaningPrice(numberOfRooms, numberOfBathrooms, typeOfFloor);


  //       await FirebaseService().addCustomerPost(title, location, typeOfFloor, description,numberOfBathrooms,numberOfBathrooms, price.toString(), time, user!.email!, 'No Image');
  //       showDialog(context: context, builder: (context){
  //         return AlertDialog(
  //           title: Text("Success"),
  //           content: Text("✅Cleaning Post Added Successfully"),
  //           actions: [
  //             TextButton(onPressed: (){
  //               Navigator.pop(context);
  //             }, child: Text("Ok"))
  //           ],
  //         );
  //       });
  //     } catch (e) {
  //       showDialog(context: context, builder: (context){
  //         return AlertDialog(
  //           title: Text("Error"),
  //           content: Text("❌Failed to add Cleaning Post"),
  //           actions: [
  //             TextButton(onPressed: (){
  //               Navigator.pop(context);
  //             }, child: Text("Ok"))
  //           ],
  //         );
  //       });
  //     }


  File? _selectedImage; 

Future<void> pickImage() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    setState(() {
      _selectedImage = File(pickedFile.path);
    });
    print("✅ Image Picked: ${pickedFile.path}");
  } else {
    print("❌ No Image Selected");
  }
}

Future<String> uploadImage(File image) async {
  try {
    String fileName = "post_images/${DateTime.now().millisecondsSinceEpoch}.jpg";

    // 🔹 Upload file to Firebase Storage
    TaskSnapshot snapshot = await FirebaseStorage.instance.ref(fileName).putFile(image);

    // 🔹 Get the download URL
    String downloadUrl = await snapshot.ref.getDownloadURL();
    
    print("✅ Image Uploaded Successfully: $downloadUrl"); // Debugging print

    return downloadUrl;
  } catch (e) {
    print("❌ Error uploading image: $e");
    return "";
  }
}

Future<void> addCleaningPost() async {
  if (!_formkey.currentState!.validate()) {
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    final title = _titleController.text;
    final location = _locationController.text;
    final typeOfFloor = _typeOfFloorController.text;
    final description = _descriptionController.text;
    final int numberOfRooms = int.tryParse(_numberOfRoomsController.text) ?? 0;
    final int numberOfBathrooms = int.tryParse(_numberOfBathroomsController.text) ?? 0;
    DateTime time = DateTime.now();

    User? user = FirebaseAuth.instance.currentUser;
    double price = calculateCleaningPrice(numberOfRooms, numberOfBathrooms, typeOfFloor);

    // 🔹 Upload image if selected, else use a placeholder image URL
    String imageUrl = "No Image";
    if (_selectedImage != null) {
      imageUrl = await uploadImage(_selectedImage!);
    }

    // 🔹 Save post with image URL in Firestore
    await FirebaseService().addCustomerPost(
      title,
      location,
      typeOfFloor,
      description,
      numberOfRooms,
      numberOfBathrooms,
      price.toString(),
      time,
      user!.email!,
      imageUrl, // ✅ Make sure this is now a proper image URL
    );

    print("✅ Cleaning Post Added with Image: $imageUrl");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("✅ Cleaning Post Added Successfully"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Ok"),
            ),
          ],
        );
      },
    );
  } catch (e) {
    print("❌ Error adding cleaning post: $e");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("❌ Failed to add Cleaning Post"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Ok"),
            ),
          ],
        );
      },
    );
  }
}

    

  // String? filename;
  // PlatformFile? pickedFile;
  // File? _image;
  //
  // Future<void> _pickImage() async{
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.image,
  //     allowedExtensions: ['jpg','jpeg','png'],
  //   );
  //   if(result != null){
  //     filename = result.files.single.path;
  //     pickedFile = result.files.first;
  //     _image = File(pickedFile!.path!.toString());
  //
  //     setState(() {
  //       _image = File(result.files.single.path!);
  //     });
  //   }
  //   print("File Name: $filename");
  // }

  String? filename;
  PlatformFile? pickedFile;
  File? _image;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      pickedFile = result.files.first;
      filename = pickedFile!.name;
      _image = File(pickedFile!.path!);

      setState(() {
        _image = File(pickedFile!.path!);
      });
    }

    print("File Name: $filename");
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.orange,
      //   title: Text("Bookings",style: GoogleFonts.roboto(
      //     textStyle: TextStyle(
      //       fontSize: 20,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),),
      // ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Lottie.asset("assets_animation/bath_sink_water_repair.json" ,
            width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
            ),
            // Image(image: AssetImage("assets/bookingMain.jpg"),
            //   width: double.infinity,
            //   height: 250,
            //   fit: BoxFit.cover,
            // ),
            Row(
              children: [
                Lottie.asset("assets_animation/addpost.json",
                  width: 75,
                  height: 75,
                  fit: BoxFit.cover,
                ),
                // // Lottie.network("https://lottie.host/b3d95598-bec1-4fcf-a346-81fd2dbe6fdb/5WoiAwfLXA.json",
                //   width: 75,
                //   height: 75,
                //   fit: BoxFit.cover,
                // ),
                Text("Add Cleaning Post",style: GoogleFonts.robotoMono(
                  textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),),
              ],
            ),
              Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      maxLength: 30,
                      decoration: InputDecoration(
                        label: Text("Enter Title",style: GoogleFonts.robotoMono(),),
                        hintText: "Enter Title of Cleaning",
                        hintStyle: TextStyle(
                          fontSize: 20,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Please Enter Title";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _locationController,
                        decoration: InputDecoration(
                          label: Text("Enter Location",style: GoogleFonts.robotoMono(),),
                          hintText: "Enter Location of Cleaning",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "Please Enter Location";
                          }
                          return null;
                        }
                        ,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _numberOfRoomsController,
                      decoration: InputDecoration(
                        label: Text("Number of Rooms",style: GoogleFonts.robotoMono(),),  
                        hintText: "Enter Number of Rooms",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Please Enter Number of Rooms";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _numberOfBathroomsController,
                      decoration: InputDecoration(
                        label: Text("Number of Bathrooms",style: GoogleFonts.robotoMono(),),
                        hintText: "Enter Number of Bathrooms",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Please Enter Number of Bathrooms";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _typeOfFloorController,
                      decoration: InputDecoration(
                        label: Text("Type Of Floor (Regular, Deep)",style: GoogleFonts.robotoMono(),),
                        hintText: "Enter Type of Floor",
                        border: OutlineInputBorder()
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Please Enter Type of Floor";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      maxLength: 50,
                      maxLines: 3,
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        label: Text("Enter Description", style: GoogleFonts.robotoMono(),),
                        hintText: "Enter Description of Cleaning",
                        hintStyle: TextStyle(
                          fontSize: 20,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Please Enter Description";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Lottie.asset("assets_animation/AddImages.json",
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                        ),
                        // Lottie.network("https://lottie.host/9d4cb928-0c2d-4cfb-8f13-2bbac7648ec1/down52IPuA.json",
                        //   width: 75,
                        //   height: 75,
                        //   fit: BoxFit.cover,
                        // ),
                        Text("Add Your Images",style: GoogleFonts.robotoMono(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _pickImage,

                        icon: Icon(Icons.image, size: 25,),
                        label: Text("Add Images",style: GoogleFonts.robotoMono(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                        ),
                      ),
                    ),
                    
                    // if(pickedFile != null)
                    //   Image.file(_image!,
                    //     width: 100,
                    //     height: 100,
                    //     fit: BoxFit.cover,
                    //   ),
                     _selectedImage != null
              ? Image.file(
                  _selectedImage!,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                )
              : Text("No Image Selected"), // Default text if no image is chosen

                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                      onPressed: ()async{
                        try{
                          await addCleaningPost();
                        }
                        catch(e){
                          print("Error: $e");
                        }
                      if(_formkey.currentState!.validate()){
                        print("Title: ${_titleController.text}");
                        print("Description: ${_descriptionController.text}");
                        print("Image: $filename");
                      }
                      else{
                        print("Please Enter Valid Data");
                      }

                    }, icon: Icon(Icons.add,
                      size: 30,
                    ),
                      label: Text("Add Cleaning Post",style: GoogleFonts.robotoMono(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                    ),
                    SizedBox(
                      height: 30,
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
