import 'package:chat_app/helpers/authenticate.dart';
import 'package:chat_app/helpers/constant.dart';
import 'package:chat_app/helpers/helpers.dart';
import 'package:chat_app/moodels/chatRoom.dart';
import 'package:chat_app/moodels/user.dart' as userModel;
import 'package:chat_app/screens/chating_page.dart';
import 'package:chat_app/screens/conversation_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/database_servise.dart';
import 'package:chat_app/widgets/my_appbar.dart';
import 'package:chat_app/widgets/style_color.dart';
import 'package:chat_app/widgets/user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../helpers/helpers.dart';

class SearchPage extends StatefulWidget {
  static final routeName = "SearchPage";

  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<userModel.User> users = [];
  List<ChatRoomModel> chatRooms = [];
  bool isLoading = false;
  bool absorbing = false;

  ChatRoomModel chatRoomModel = ChatRoomModel();
  getData() async {
    var a = await DataBaseService()
        .getUserData(FirebaseAuth.instance.currentUser.uid);
    print(a);
    if (mounted)
      setState(() {
        users = a;
      });
  }

  getChats() async {
    var listRooms = await DataBaseService().getAllChats();
    setState(() {
      chatRooms = listRooms;
    });
  }

  sendMesasge({String toId, String toName}) async {
    setState(() {
      isLoading = true;
      absorbing = true;
    });

    Constant.myName = await HelperFunctions.getUserName();
    Constant.myID = await HelperFunctions.getUserCurrentId();
    String chatRoomId = generateChatRoomId(Constant.myID, toId);
    bool isContainsSimilarRoom = await DataBaseService()
        .cheackRoomUniqe(toId: toId, fromId: Constant.myID);
    bool isRoomUniqeByCurrent = await DataBaseService()
        .cheackRoomUniqeByCurrent(toId: toId, fromId: Constant.myID);

    chatRoomModel.chatRoomId = chatRoomId;
    chatRoomModel.fromId = Constant.myID;
    chatRoomModel.fromName = Constant.myName;
    chatRoomModel.toId = toId;
    chatRoomModel.toName = toName;

    if (chatRooms.isNotEmpty) {
      print("now not empty");
      await DataBaseService().addchatRoom(chatRoomId, chatRoomModel);
      Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (contex) => ChatIngPage(
                    chatRoomId: chatRoomId,
                    name: toName,
                  )))
         ;
    } else {
      if (isContainsSimilarRoom == true) {
        chatRoomId = toId + Constant.myID;
        print("it is similar rooms");
        print(toId + Constant.myID);
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (contex) =>
                    ChatIngPage(chatRoomId: chatRoomId, name: toName)))
           ;
      } else {
        if (isRoomUniqeByCurrent == true) {
          print("curret not add");
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (contex) =>
                      ChatIngPage(chatRoomId: chatRoomId, name: toName)))
             ;
        } else {
          print("ok");
          await DataBaseService().addchatRoom(chatRoomId, chatRoomModel);
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (contex) =>
                      ChatIngPage(chatRoomId: chatRoomId, name: toName)))
             ;
        }
      }
    }
    setState(() {
      isLoading = false;
      absorbing = false;
    });
  }

  generateChatRoomId(String myId, String userId) {
    return myId + "" + userId;
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool _pinned = true;
    bool _snap = false;
    bool _floating = false;

    return Stack(
      children: [
        AbsorbPointer(
          absorbing: absorbing,
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () async {
                            Navigator.of(context)
                                .pushNamed(ChatRoom.routeName);
                          }),
                      title: Text(
                       Constant.myName,
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
        ),
        if (isLoading)
          Center(
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(65),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://media.giphy.com/media/3ov9k4dawRrTNyVE3K/giphy.gif"))),
            ),
          )
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
        itemCount: users.length,
        itemBuilder: (contex, index) {
          return UserCard(
            onTap: () {
              sendMesasge(
                  toId: users[index].id,
                  toName: users[index].name + " " + users[index].surname);
            },
            user: users[index],
          );
        },
      ),
    );
  }
}
