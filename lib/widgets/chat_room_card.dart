import 'package:chat_app/helpers/constant.dart';
import 'package:chat_app/moodels/chatRoom.dart';
import 'package:chat_app/moodels/user.dart';
import 'package:chat_app/widgets/buttons.dart';
import 'package:chat_app/widgets/style_color.dart';
import 'package:flutter/material.dart';

class ChatRoomCard extends StatelessWidget {
  ChatRoomCard({this.chatRoomModel, this.onTap,this.lastMessage});
  Function onTap;
  String lastMessage;
  final ChatRoomModel chatRoomModel;
  String imageUrl =
      'https://www.vhv.rs/dpng/d/426-4263064_circle-avatar-png-picture-circle-avatar-image-png.png';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
          child: Container(
         decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
        height: 80,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.all(8),
              child: CircleAvatar(  
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(Constant.myID != chatRoomModel.fromId ? chatRoomModel.fromName:chatRoomModel.toName,
                      style: nameSurnameTextStayleInCards
                    ),
                    Text(lastMessage ?? "")
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
