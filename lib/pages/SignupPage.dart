import 'package:bubble/pages/CompleteProfile.dart';
import 'package:bubble/pages/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bubble/models/UserModel.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _cPassword = TextEditingController();

  void checkValues(){
    String email = _email.text.trim();
    String password = _password.text.trim();
    String cPassword = _cPassword.text.trim();
    
    if(email == "" || password == "" || cPassword == ""){
      print("No field can be left blank!");
    }else if(password != cPassword){
      print("Passwords do not match!");
    }else{
      signUp(email, password);
    }
    
  }

  void signUp(String email, String password) async {
    UserCredential? credential;

    try{
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(e){
      print(e.message.toString());
    }

    if(credential != null){
      String uid = credential.user!.uid;

      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        fullname: "",
        profilepic: "",
      );

      await FirebaseFirestore.instance.collection("users").doc(uid).set(newUser.toMap()).then((value){
        print("Created New User!");
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return CompleteProfile(userModel: newUser, firebaseUser: credential!.user!);
        }));
        
      });

    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // InkWell(
                  //   child: Image.asset("assets/images/curved_arrow.png", height: 30.0,),
                  //   onTap: (){},
                  // ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Let's bubble you up.",
                    style: GoogleFonts.poppins(
                        fontSize: 38,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "with the people.\nyou love!",
                    style: GoogleFonts.poppins(
                        fontSize: 32, color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(
                    height: 80.0,
                  ),
                  TextField(
                     controller: _email,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      contentPadding: EdgeInsets.all(24.0),
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.email,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            width: 3, color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      contentPadding: EdgeInsets.all(24.0),
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.password,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            width: 3, color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: _cPassword,
                    obscureText: true,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      contentPadding: EdgeInsets.all(24.0),
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.password,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            width: 3, color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  LoginPage()),
                            );
                          },
                          child: Text(
                            "Sign In",
                            style: GoogleFonts.poppins(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    height: 68,
                    child: CupertinoButton(
                      child: Text(
                        "Sign up",
                        style: GoogleFonts.poppins(fontSize: 22),
                      ),
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(18),
                      onPressed: () {
                        checkValues();
                        // Navigator.push(context,
                        //   MaterialPageRoute(builder: (context)=> CompleteProfile()),);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
