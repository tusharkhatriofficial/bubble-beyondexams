import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bubble/pages/SignupPage.dart';
import 'package:bubble/pages/LoginPage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
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
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Let's bubble you up.",
                        style: GoogleFonts.poppins(
                            fontSize: 36,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "With the people\nyou love!",
                        style: GoogleFonts.poppins(
                            fontSize: 32, color: Theme.of(context).primaryColor),
                      ),
                      const SizedBox(
                        height: 80.0,
                      ),
                      Center(
                        child: SvgPicture.asset(
                          "assets/images/hero_1.svg",
                          height: 280,
                        ),
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
                                "Sign In",
                                style: GoogleFonts.poppins(fontSize: 22),
                              ),
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(18),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return LoginPage();
                                }),);
                              },
                            ),
                          ),
                      SizedBox(height: 10.0,),
                      Container(
                        width: double.infinity,
                        height: 68,
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: CupertinoButton(
                          child: Text(
                            "Sign up",
                            style: GoogleFonts.poppins(fontSize: 22),
                          ),
                          borderRadius: BorderRadius.circular(18),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return SignupPage();
                            }),);
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
