import 'package:bubble/pages/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bubble/pages/CompleteProfile.dart';
import 'firebase_options.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:bubble/pages/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bubble/models/firebaseHelper.dart';
import 'package:bubble/models/UserModel.dart';
import 'package:uuid/uuid.dart';
import 'package:bubble/pages/welcomePage.dart';

var uuid = Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  User? currentUser = FirebaseAuth.instance.currentUser;
  if(currentUser != null){
    //logged in

    UserModel? thisUserModel = await FirebaseHelper.getUserModelById(currentUser.uid);
    if(thisUserModel != null){
      runApp(MyAppLoggedIn(userModel: thisUserModel, firebaseUser: currentUser,));
    }else{
      runApp(MyApp());
    }

  }else{
    //not logged in
    runApp(MyApp());
  }

}




//When user is logged out or new
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: const Color(0xff0168FF),
        cupertinoOverrideTheme: const CupertinoThemeData(
          primaryColor: Color(0xff0168FF),

        ),
      ),
      home: WelcomePage(),
    );
  }
}



// When user is logged in
class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn({Key? key, required this.firebaseUser, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: const Color(0xff0168FF),
        cupertinoOverrideTheme: const CupertinoThemeData(
          primaryColor: Color(0xff0168FF),

        ),
      ),
      home: HomePage(userModel: userModel, firebaseUser: firebaseUser),
    );
  }
}

