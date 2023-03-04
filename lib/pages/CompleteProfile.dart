import 'package:bubble/pages/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/CustomWidgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:bubble/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CompleteProfile extends StatefulWidget {

  final UserModel userModel;
  final User firebaseUser;

  const CompleteProfile({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {

  late File? imageFile;
  CroppedFile? finalFile = null;
  TextEditingController _fullNameController = TextEditingController();

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if(pickedFile != null){
      cropImage(pickedFile);
    }

  }

  void cropImage(XFile file) async {
    CroppedFile? cropperdImage = await ImageCropper().cropImage(
        sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 20
    );

    if(cropperdImage != null){
      setState(() {
        finalFile = cropperdImage;
      });
    }
  }

  void uploadData() async {
    UploadTask uploadTask = FirebaseStorage.instance.ref("profilePictures").child(widget.userModel.uid.toString()).putFile(File(finalFile!.path));
    TaskSnapshot  snapshot = await uploadTask;
    String uploadedImageUrl = await snapshot.ref.getDownloadURL();
    String fullName = _fullNameController.text.trim();
    widget.userModel.fullname = fullName;
    widget.userModel.profilepic = uploadedImageUrl;
    await FirebaseFirestore.instance.collection("users").doc(widget.userModel.uid).set(widget.userModel.toMap()).then((value){

      print("Data updated!");
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return HomePage(userModel: widget.userModel, firebaseUser: widget.firebaseUser,);
      }));

    });
  }

  void checkValues(){
    String fullName = _fullNameController.text.trim();
    if(fullName == "" || finalFile == null){
      print("Please fill all the fields");
    }else{
      uploadData();
    }
  }


  void showPhotoOptions(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        shadowColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(12.0)),
          title: Text("Upload Profile Picture"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
                leading: Icon(Icons.photo_album, color: Theme.of(context).primaryColor,),
                title: Text("Select from Gallery"),
              ),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                },
                leading: Icon(Icons.camera_alt, color: Theme.of(context).primaryColor,),
                title: Text("Take a Photo"),
              ),
            ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40,),
                  Text(
                    "Complete your profile.",
                    style: GoogleFonts.poppins(
                        fontSize: 30,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "A completed profile.\nlooks good!",
                    style: GoogleFonts.poppins(
                        fontSize: 25, color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(height: 80,),
                  Center(
                    child: CupertinoButton(
                      child: CircleAvatar(
                        child: (finalFile==null)? Icon(Icons.person, color: Colors.white, size: 40,): null,
                        radius: 60,
                        backgroundColor: Theme.of(context).primaryColor,
                        backgroundImage: (finalFile!=null)?  AssetImage(finalFile!.path.toString()):
                        null,
                      ),
                      onPressed: (){
                        showPhotoOptions();
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  BubbleTextField(
                    controller: _fullNameController,
                    hintText: "Full Name",
                    icon: Icons.person,
                    color: Theme.of(context).primaryColor,
                    obsecureText: false,
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 68,
                    child: CupertinoButton(
                      child: Text(
                        "Continue",
                        style: GoogleFonts.poppins(fontSize: 22),
                      ),
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(18),
                      onPressed: () {
                       checkValues();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

