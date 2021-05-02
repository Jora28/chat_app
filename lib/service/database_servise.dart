import 'package:chat_app/moodels/chatRoom.dart';
import 'package:chat_app/moodels/user.dart' as userModel;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataBaseService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore store;

  Future postUser(userModel.User model) async {
    model.id = auth.currentUser.uid;
    return await FirebaseFirestore.instance
        .collection("usersCollectionPath")
        .doc(auth.currentUser.uid)
        .set(model.toJson());
  }

  Future<List<userModel.User>> getUserData(String id) async {
    var res = await FirebaseFirestore.instance
        .collection('usersCollectionPath')
        .where('id', isNotEqualTo: id)
        .get();
    var doc = res.docs.map((element) {
      return userModel.User.fromJson(element.data());
    }).toList();
    return doc;
  }

  Future<userModel.User> getCurrentUserData(String id) async {
    var res = await FirebaseFirestore.instance
        .collection('usersCollectionPath')
        .doc(auth.currentUser.uid)
        .get();

    return userModel.User.fromJson(res.data());
  }

  Future addchatRoom(String roomId, ChatRoomModel chatRoomModel) async {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(roomId)
        .set(chatRoomModel.toJson())
        .catchError((e) {
      print(e.toString());
    });
  }

  addMessage(String chatRoomId, chatMessageData) async {
    await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<bool> cheackRoomUniqeByCurrent({String fromId, String toId}) async {
    var res = await FirebaseFirestore.instance
        .collection("chatRoom")
        .where(
          'fromId',
          isEqualTo: fromId,
        )
        .where('toId', isEqualTo: toId)
        .get();
    print("this what i want ${res.docs}");
    if (res.docs.isNotEmpty) {
      var doc = res.docs.map((e) {
        return ChatRoomModel.fromJson(e.data());
      }).toList();
      print({'this cheack value $doc'});
      return true;
    } else {
      return false;
    }
  }

  Future<void> setLastMessage(String chatRoomId, String lastMessage) async {
    return FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .update({'lastMessage': lastMessage})
        .then((value) => print("User Updated"))
        .catchError((onError) => print("Faild to user up date"));
  }

  Future<bool> cheackRoomUniqe({String fromId, String toId}) async {
    var res = await FirebaseFirestore.instance
        .collection("chatRoom")
        .where(
          'fromId',
          isEqualTo: toId,
        )
        .where('toId', isEqualTo: fromId)
        .get();
    print("this what i want ${res.docs}");
    if (res.docs.isNotEmpty) {
      var doc = res.docs.map((e) {
        return ChatRoomModel.fromJson(e.data());
      }).toList();
      print({'this cheack value $doc'});
      return true;
    } else {
      return false;
    }
  }

  getMessage(String chatRoomId) async {
    var a = FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time', descending: true)
        .snapshots();
    return a;
  }

    Future<List<ChatRoomModel>> getAllChats() async {
    var doc = await FirebaseFirestore.instance
        .collection("chatRoom")
        .get();
    return doc.docs.map((e) {
      return ChatRoomModel.fromJson(e.data());
    }).toList();
  }

  Future<List<ChatRoomModel>> getUserChatsTo() async {
    var doc = await FirebaseFirestore.instance
        .collection("chatRoom")
        .where('toId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        //  .where('fromId',isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get();
    return doc.docs.map((e) {
      return ChatRoomModel.fromJson(e.data());
    }).toList();
  }

  Future<List<ChatRoomModel>> getUserChatsFrom() async {
    var doc = await FirebaseFirestore.instance
        .collection("chatRoom")
        //.where('toId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
          .where('fromId',isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get();
    return doc.docs.map((e) {
      return ChatRoomModel.fromJson(e.data());
    }).toList();
  }
}
