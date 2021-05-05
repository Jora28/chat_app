import 'package:chat_app/helpers/authenticate.dart';
import 'package:chat_app/helpers/constant.dart';
import 'package:chat_app/helpers/helpers.dart';
import 'package:chat_app/moodels/chatRoom.dart';
import 'package:chat_app/screens/chating_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/database_servise.dart';
import 'package:chat_app/widgets/chat_room_card.dart';
import 'package:chat_app/widgets/my_appbar.dart';
import 'package:chat_app/widgets/style_color.dart';
import 'package:flutter/material.dart';
import '../helpers/helpers.dart';

class ChatRoom extends StatefulWidget {
  static final routeName = "ChatRoom";

  ChatRoom({Key key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  List<ChatRoomModel> chatRooms = [];
  bool isLoading = false;

  ChatRoomModel chatRoomModel = ChatRoomModel();

  getChats() async {
    setState(() {
      isLoading = true;
    });
    Constant.myName = await HelperFunctions.getUserName();
    Constant.myID = await HelperFunctions.getUserCurrentId();
    var listRoomsTo = await DataBaseService().getUserChatsTo();
    var listRoomsFrom = await DataBaseService().getUserChatsFrom();
    setState(() {
      chatRooms = listRoomsTo + listRoomsFrom;
      isLoading = false;
    });
  }

  @override
  void initState() {
    getChats();
    super.initState();
  }

  sendMesasge({ChatRoomModel chatRoomModel}) async {
    print("now not empty");
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (contex) => ChatIngPage(
                  chatRoomId: chatRoomModel.chatRoomId,
                  name: Constant.myID != chatRoomModel.fromId
                      ? chatRoomModel.fromName
                      : chatRoomModel.toName,
                )))
        .then((value) {
      if (value) {
        initState();
      } else {
        print('fasle');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool _pinned = true;
    bool _snap = false;
    bool _floating = false;

    return Stack(
      children: [
        Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                    title: Text(
                      "Good Morning,${Constant.myName}",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    backgroundColor: newColor4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                    ),
                    actions: [
                      IconButton(
                          icon: Icon(Icons.logout),
                          onPressed: () async {
                            HelperFunctions.saveLogged(false);
                            HelperFunctions.saveUserCurrentId("");
                            HelperFunctions.saveUserName("");
                            HelperFunctions.saveUserEmail("");
                            await AuthServise().logout();
                            Navigator.of(context)
                                .pushReplacementNamed(Authenticate.routeName);
                          })
                    ],
                    pinned: _pinned,
                    snap: _snap,
                    floating: _floating,
                    expandedHeight: 120.0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: AppBarSliver(),
                    )),
              ];
            },
            body: _body(),
          ),
        ),
        if (isLoading)
          Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ))
      ],
    );
  }

  Widget _body() {
    return Container(
      margin: EdgeInsets.only(top: 0),
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: chatRooms.length,
        itemBuilder: (contex, index) {
          return ChatRoomCard(
            onTap: () {
              sendMesasge(chatRoomModel: chatRooms[index]);
            },
            chatRoomModel: chatRooms[index],
            lastMessage: chatRooms[index].lastMessage,
          );
        },
      ),
    );
  }
}
