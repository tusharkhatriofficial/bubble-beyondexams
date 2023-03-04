import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bubble/models/UserModel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bubble/pages/searchPage.dart';
import 'package:bubble/main.dart';
import 'package:bubble/models/ChatRoomModel.dart';
import 'package:bubble/models/firebaseHelper.dart';
import 'package:bubble/pages/chatRoomPage.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const HomePage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  //Sign out user
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // bool showChatTiles = false;
  //
  // Future<void> findChats() async {
  //   QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("chatrooms").where("participants.${widget.userModel.uid}", isEqualTo: true).get();
  //   print("this function ran once");
  //   if(snapshot.docs.length > 0){
  //       showChatTiles = true;
  //   }else{
  //       showChatTiles = false;
  //   }
  // }


  //custom bottom sheet
  Future<dynamic> showCustomBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10,),
                ListTile(
                  title: Text("Signout", style: GoogleFonts.poppins(fontSize: 20)),
                  onTap: (){

                    _signOut().then((value){
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c) => MyApp()), (route) => false);

                    });

                  },
                  leading: Icon(
                    Icons.logout_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 10,),
                ListTile(
                  title: Text("Version 0.0.1", style: GoogleFonts.poppins(fontSize: 20),),
                  leading: Icon(
                    Icons.info,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 20,),
              ],
            ),
          );
        });
  }


  Widget emptyInbox(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image.asset("assets/images/void.png", height: 240,),
          SvgPicture.asset(
            "assets/images/void.svg",
            height: 240,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Your inbox is empty!",
            style: GoogleFonts.poppins(
                fontSize: 28,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Once you start a new conversation,",
            style: GoogleFonts.poppins(
                fontSize: 15, color: Theme.of(context).primaryColor),
          ),
          Text(
            "you'll se it listed here.",
            style: GoogleFonts.poppins(
                fontSize: 15, color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bubble...", style: GoogleFonts.poppins(fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            size: 35,
          ),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            showCustomBottomSheet(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("chatrooms").where("participantslist", arrayContains: widget.firebaseUser.uid).orderBy("lastmessagedate", descending: true).snapshots(),
        builder: (context, snapshot) {

          if(snapshot.connectionState == ConnectionState.active){
            if(snapshot.hasData){
              QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;
              if (chatRoomSnapshot.docs.length > 0) {
                return ListView.builder(
                  itemCount: chatRoomSnapshot.docs.length,
                  itemBuilder: (context, index){
                    ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(chatRoomSnapshot.docs[index].data() as Map<String, dynamic>);
                    Map<String, dynamic> participants = chatRoomModel.participants!;
                    List<String> participantKeys = participants.keys.toList();
                    List<String> users = participants.keys.toList();
                    participantKeys.remove(widget.userModel.uid);

                    return FutureBuilder(
                      future: FirebaseHelper.getUserModelById(participantKeys[0]),
                      builder: (context, userData){
                        if(userData.connectionState == ConnectionState.done){
                          if(userData.data != null){
                            UserModel targetUser = userData.data as UserModel;
                            return ListTile(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return ChatRoomPage(targetModel: targetUser, chatroom: chatRoomModel, userModel: widget.userModel, firebaseUser: widget.firebaseUser);
                                }));
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(targetUser.profilepic.toString()),
                              ),
                              title: Text(targetUser.fullname.toString()),
                              subtitle: (chatRoomModel.lastMessage.toString() != "")? Text(chatRoomModel.lastMessage.toString()): Text("Say hi to your new friend!", style: GoogleFonts.poppins(color: Theme.of(context).primaryColor),),
                            );
                          }else{
                            return Container();
                          }
                        }else{
                          return Container();
                        }

                      },

                    );
                  },
                );
              }else{
                return emptyInbox();
              }
            }else if(snapshot.hasError){
              print(snapshot.error.toString());
              return Center(child: Text(snapshot.error.toString(),),);
            }else{
              return Center(child: Text(""),);
            }
          }else{
            return Center(child: CircularProgressIndicator(),);
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return SearchPage(userModel: widget.userModel, firebaseUser: widget.firebaseUser);
          }));
        },
      ),
    );
  }
}


