class ChatRoomModel{
  String? chatroomid;
  Map<String, dynamic>? participants;
  List? participantsList;
  String? lastMessage;
  DateTime? lastMessageDate;

  ChatRoomModel({this.chatroomid, this.participants, this.lastMessage, this.lastMessageDate, this.participantsList});

  //from map constructor
  ChatRoomModel.fromMap(Map<String, dynamic> map){
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    participantsList = map["participantslist"];
    lastMessage = map["lastmessage"];
    lastMessageDate = map["lastMessageDate"];
  }

  //toMap function
  Map<String, dynamic> toMap(){
    return {
      "chatroomid": chatroomid,
      "participants": participants,
      "participantslist": participantsList,
      "lastmessage": lastMessage,
      "lastmessagedate": lastMessageDate,
    };
  }


}