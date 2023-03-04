class MessageModel{
  String? messageId;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdon;

  MessageModel({this.messageId, this.text, this.createdon, this.seen, this.sender});

  // from map constructor
  MessageModel.fromMap(Map<String, dynamic> map){
    messageId = map["messageid"];
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdon = map["createdon"].toDate();
  }

  //to map constructor
  Map<String, dynamic> toMap(){
    return {
      "messageid": messageId,
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdon": createdon,
    };
  }


}