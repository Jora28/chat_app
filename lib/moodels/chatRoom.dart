class ChatRoomModel {
  String fromId;
  String toId;
  String toName;
  String fromName;
  String chatRoomId;
  String lastMessage;

  ChatRoomModel({this.fromId,this.toId,this.chatRoomId,this.lastMessage,this.fromName,this.toName});

  factory ChatRoomModel.fromJson(json) {
    return ChatRoomModel(
      chatRoomId: json['chatRoomId'],
      fromId: json['fromId'],
      fromName: json['fromName'],
      toName: json['toName'],
      lastMessage: json['lastMessage'],
      toId: json['toId'],
      );
  }

  Map<String, dynamic> toJson() {
    var data = Map<String, dynamic>();
    data['chatRoomId'] = this.chatRoomId;
    data["fromId"] = this.fromId;
    data['fromName'] = this.fromName;
    data['toName'] = this.toName;
    data["toId"] = this.toId;
    data['lastMessage'] = this.lastMessage;
    return data;
  }
}
