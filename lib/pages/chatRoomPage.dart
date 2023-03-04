import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bubble/models/UserModel.dart';
import 'package:bubble/models/ChatRoomModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bubble/models/MessageModel.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targetModel;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoomPage({Key? key, required this.targetModel, required this.chatroom, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  var uuid = Uuid();

  TextEditingController _messageController = TextEditingController();

  void sendMessage() async {
    String msg = _messageController.text.trim();
    _messageController.clear();
    if(msg != ""){
      //Send Message
      MessageModel newMessage = MessageModel(
        messageId: uuid.v1(),
        sender: widget.userModel.uid,
        createdon: DateTime.now(),
        text: msg,
        seen: false,
      );

      FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).collection("messages").doc(newMessage.messageId).set(
        newMessage.toMap()
      );

      widget.chatroom.lastMessage = msg;
      widget.chatroom.lastMessageDate = DateTime.now();
      widget.chatroom.participantsList = [widget.firebaseUser.uid, widget.targetModel.uid];
      FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).set(widget.chatroom.toMap());

      print("message Sent");

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(backgroundColor: Colors.transparent, backgroundImage: NetworkImage(widget.targetModel.profilepic.toString()),),
            SizedBox(width: 20,),
            Text(widget.targetModel.fullname!, style: GoogleFonts.poppins(color: Colors.black),),
          ],
        ),
        leading: CupertinoButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Theme.of(context).primaryColor,
            ),
          ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).collection("messages").orderBy("createdon", descending: true).snapshots(),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.active){
                      if(snapshot.hasData){
                        QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                        return ListView.builder(
                          reverse: true,
                          itemCount: dataSnapshot.docs.length,
                          itemBuilder: (context, index){
                            MessageModel currentMessage = MessageModel.fromMap(dataSnapshot.docs[index].data() as Map<String, dynamic>);
                            return Row(
                              mainAxisAlignment: (currentMessage.sender == widget.userModel.uid)? MainAxisAlignment.end: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 2),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 10
                                  ),
                                  decoration: BoxDecoration(
                                      color: (currentMessage.sender == widget.userModel.uid)? Theme.of(context).primaryColor: Color(0xffEEEEEE),
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Text(currentMessage.text.toString(), style: GoogleFonts.poppins(
                                    color: (currentMessage.sender == widget.userModel.uid)? Colors.white: Colors.black,
                                  ),),
                                ),
                              ],
                            );
                          },
                        );
                      }else if(snapshot.hasError){
                        return Center(child: Text("An error occured! Please check your internet connection."),);
                      }else{
                        return Center(child: Text("Say hi to your new friend!"),);
                      }
                    }else{
                      return Center(child: CircularProgressIndicator(),);
                    }
                  },
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    minLines: 1,
                    maxLines: null,
                    controller: _messageController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Message",
                      suffixIcon: IconButton(icon: Icon(Icons.send_outlined, color: Theme.of(context).primaryColor,), onPressed: (){
                        sendMessage();
                      },),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
