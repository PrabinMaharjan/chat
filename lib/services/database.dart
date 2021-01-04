import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods{

  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection("users")
        .add(userMap);
  }

  Future getUserByName(String userName)async{
    return await FirebaseFirestore.instance.collection("users")
        .where("name",isEqualTo: userName)
    .get();
  }

  Future getUserByEmail(String userEmail)async{
    return await FirebaseFirestore.instance.collection("users")
        .where("email",isEqualTo: userEmail)
        .get();
  }

  createChatRoom(String chatRoomId, chatRoomMap){
    FirebaseFirestore.instance.collection("chat_room")
        .doc(chatRoomId).set(chatRoomMap).catchError((e){
          print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap){
    FirebaseFirestore.instance.collection("chat_room")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e){print(e.toString());});
  }

  getConversationMessages(String chatRoomId){
    return FirebaseFirestore.instance.collection("chat_room")
        .doc(chatRoomId)
        .collection("chats")
    .orderBy("time")
        .snapshots();
  }

  getChatRooms(String userName)async{
    return await FirebaseFirestore.instance.collection("chat_room")
        .where("users", arrayContains: userName).snapshots();
  }

}