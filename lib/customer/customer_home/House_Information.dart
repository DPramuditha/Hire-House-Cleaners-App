import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_cleaners_app/customer/pages_move.dart';
import 'package:house_cleaners_app/firebase/firebase_service.dart';
import 'package:lottie/lottie.dart';

class HouseInformation extends StatefulWidget {
  const HouseInformation({super.key});

  @override
  State<HouseInformation> createState() => _HouseInformationState();
}

class _HouseInformationState extends State<HouseInformation> {

  TextEditingController _houseNameController = TextEditingController();
  TextEditingController _houseAddressController = TextEditingController();
  TextEditingController _numberOfRoomsController = TextEditingController();
  TextEditingController _numberOfBathroomsController = TextEditingController();
  TextEditingController _flooringTypeController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

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


  bool isLoading = false;
  Future houseInfo() async{
    if(!_formkey.currentState!.validate()){
      return;
    }
    setState(() {
      isLoading = true;
    });

    try{
      final houseName = _houseNameController.text.trim();
      final houseAddress = _houseAddressController.text.trim();
      final flooryingType = _flooringTypeController.text.trim();
      final numberOfRooms = int.parse(_numberOfRoomsController.text.trim());
      final numberOfBathrooms = int.parse(_numberOfBathroomsController.text.trim());

      User? user = FirebaseAuth.instance.currentUser;

      await FirebaseService().AddHouseInfomation(houseName, houseAddress, numberOfRooms, numberOfBathrooms, flooryingType,user!.email!);
      print("😘House Information added successfully!");
      showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            title: Text("House Information Added Successfully",style: GoogleFonts.rubik(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("OK",style: GoogleFonts.rubik(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),)),
            ],
          );
      
        }
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> PagesMove()));
    }
    catch(e){
      print("😡Failed to add House Information $e");
      showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            title: Text("Failed to add House Information",style: GoogleFonts.rubik(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("OK",style: GoogleFonts.rubik(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),)),
            ],
          );
      
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Lottie.asset("assets_animation/house.json",
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),

            Text("House Information",style: GoogleFonts.rubik(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),),
            Form(
              key: _formkey,
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _houseNameController,
                    decoration: InputDecoration(
                      labelText: "House Name",
                      hintText: "Enter House Name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.home),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please Enter House Name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _houseAddressController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "House Address",
                      hintText: "Enter House Address",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please Enter House Address";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _numberOfRoomsController,
                    decoration: InputDecoration(
                      labelText: "Number of Rooms",
                      hintText: "Enter Number of Rooms",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.meeting_room),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
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
                      labelText: "Number of Bathrooms",
                      hintText: "Enter Number of Bathrooms",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.bathtub),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please Enter Number of Bathrooms";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _flooringTypeController,
                    decoration: InputDecoration(
                      labelText: "Flooring Type",
                      hintText: "Enter Flooring Type(Tiles,Carpet,Wooden)",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.home_repair_service),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please Enter Flooring Type";
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
                      ),
                      Text("Upload House Image",style: GoogleFonts.rubik(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(onPressed: (){
                      _pickImage();

                    }, icon: Icon(Icons.image, color: Colors.white,),
                    label: Text("Upload Image",style: GoogleFonts.rubik(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff5656ff),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  if(_image != null)
                    Image.file(_image!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async{
                      try{
                        await houseInfo();  
                      }
                      catch(e){
                        print("😡Failed to add House Information $e");
                      }
                    if(_formkey.currentState!.validate()){
                      print("House Name: ${_houseNameController.text}");
                      print("House Address: ${_houseAddressController.text}");
                      print("Number of Rooms: ${_numberOfRoomsController.text}");
                      print("Number of Bathrooms: ${_numberOfBathroomsController.text}");
                      print("Flooring Type: ${_flooringTypeController.text}");
                    }
                    else{
                      print("Please Enter Valid Data");
                    }
                    
                  }, icon: Icon(Icons.upload, color: Colors.white,),
                  label: Text("Upload House Information",style: GoogleFonts.rubik(
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
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> PagesMove()));
                    }, icon: Icon(Icons.keyboard_double_arrow_right_sharp,size: 20, ),
                    label: Text("Skip This",style: GoogleFonts.rubik(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    
                    ),),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
