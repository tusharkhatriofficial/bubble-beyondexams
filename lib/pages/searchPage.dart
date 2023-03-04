import 'package:flutter/material.dart';
import 'package:bubble/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bubble/widgets/CustomWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bubble/pages/chatRoomPage.dart';
import 'package:bubble/models/ChatRoomModel.dart';
import 'package:uuid/uuid.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const SearchPage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var uuid = Uuid();
  TextEditingController _searchTermController = TextEditingController();

  Future<ChatRoomModel?> getChatRoomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      print("Chatroom already created!");
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      chatRoom = existingChatroom;
    } else {
      ChatRoomModel newChatroom =
          ChatRoomModel(chatroomid: uuid.v1(), lastMessage: "", participants: {
        widget.userModel.uid.toString(): true,
        targetUser.uid.toString(): true,
      });

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;
      print("New Chatrooms created.");
    }
    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                " Look for a user  👀",
                style: GoogleFonts.poppins(
                    fontSize: 30,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: BubbleTextField(
                      onChanged: (String) {
                        setState(() {});
                      },
                      controller: _searchTermController,
                      hintText: "Search with email address",
                      color: Theme.of(context).primaryColor,
                      icon: null,
                      obsecureText: false,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: FloatingActionButton(
                      child: Center(
                        child: Icon(Icons.search),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("email",
                        isEqualTo: _searchTermController.text.trim())
                    .where("email", isNotEqualTo: widget.firebaseUser.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;
                      if (dataSnapshot.docs.length > 0) {
                        Map<String, dynamic> userMap =
                            dataSnapshot.docs[0].data() as Map<String, dynamic>;
                        UserModel foundUser = UserModel.fromMap(userMap);
                        return ListTile(
                          onTap: () async {
                            ChatRoomModel? chatRoomModel =
                                await getChatRoomModel(foundUser);

                            if (chatRoomModel != null) {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ChatRoomPage(
                                      targetModel: foundUser,
                                      firebaseUser: widget.firebaseUser,
                                      userModel: widget.userModel,
                                      chatroom: chatRoomModel,
                                    );
                                  },
                                ),
                              );
                            }
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                NetworkImage(foundUser.profilepic!),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.bubble_chart_sharp),
                            color: Theme.of(context).primaryColor,
                            onPressed: () async {
                              ChatRoomModel? chatRoomModel =
                              await getChatRoomModel(foundUser);

                              if (chatRoomModel != null) {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ChatRoomPage(
                                        targetModel: foundUser,
                                        firebaseUser: widget.firebaseUser,
                                        userModel: widget.userModel,
                                        chatroom: chatRoomModel,
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                          title: Text(foundUser.fullname!),
                          subtitle: Text(foundUser.email!),
                        );
                      } else {
                        return Text("");
                      }
                    } else if (snapshot.hasError) {
                      return Text(" An error occurred!");
                    } else {
                      return Text(" No results found!");
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
