import 'dart:async';

import 'package:chat_app/helpers/constant.dart';
import 'package:chat_app/helpers/helpers.dart';
import 'package:chat_app/moodels/user.dart';
import 'package:chat_app/screens/conversation_page.dart';
import 'package:chat_app/service/database_servise.dart';
import 'package:chat_app/widgets/inpurs.dart';
import 'package:chat_app/widgets/message_card.dart';
import 'package:chat_app/widgets/style_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ChatIngPage extends StatefulWidget {
  static final routeName = "ChatingPage";
  final String chatRoomId;
  final String name;
  ChatIngPage({this.chatRoomId, this.name});

  @override
  _ChatIngPageState createState() => _ChatIngPageState();
}

class _ChatIngPageState extends State<ChatIngPage> {
  TextEditingController _messageController = TextEditingController();
  var _scrollController = ScrollController();
  Stream<QuerySnapshot> chatMessageStrem;
  String imageUrl =
      'https://www.vhv.rs/dpng/d/426-4263064_circle-avatar-png-picture-circle-avatar-image-png.png';

  bool isLoading = false;
  getInfo() async {
    Constant.myID = await HelperFunctions.getUserCurrentId();
  }

  @override
  void initState() {
    getInfo();

    DataBaseService().getMessage(widget.chatRoomId).then((val) {
      setState(() {
        chatMessageStrem = val;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: _body(),
    );
  }

  Widget addMessageList() {
    return StreamBuilder(
        stream: chatMessageStrem,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  dragStartBehavior: DragStartBehavior.down,
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return MessageCard(
                      message: snapshot.data.docs[index].data()["message"],
                      sendByMe: Constant.myID ==
                          snapshot.data.docs[index].data()["sendBy"],
                    );
                  })
              : Container();
        });
  }

  sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': _messageController.text,
        'sendBy': Constant.myID,
        'time': DateTime.now()
      };
      var rea =
          await DataBaseService().addMessage(widget.chatRoomId, messageMap);

      await DataBaseService()
          .setLastMessage(widget.chatRoomId, _messageController.text);
      _messageController.clear();
      print(rea);
    }
  }

  Widget _body() {
    return Column(
      children: [
        Container(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.only(top:10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name ?? "",
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Text("Active now",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 10))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: newColor4,
          ),
        ),
        Expanded(
          child: addMessageList(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, offset: Offset(0, 1), blurRadius: 5),
                ],
                borderRadius: BorderRadius.circular(30)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomInput(
                    prefix: Icons.email_outlined,
                    color: Colors.white,
                    controller: _messageController,
                    hintText: "Message",
                  ),
                )),
                InkWell(
                  onTap: () {
                    sendMessage();
                    _scrollController.animateTo(0,
                        duration: Duration(milliseconds: 50),
                        curve: Curves.easeIn);
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    height: 40,
                    width: 40,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: newColor4),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
