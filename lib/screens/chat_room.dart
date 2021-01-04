import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/screens/conversation.dart';
import 'package:chat_app/screens/search.dart';
import 'package:chat_app/services/authentication.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  Stream chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                      snapshot.data.docs[index]["chatroomId"]
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constants.myName, ""),
                      snapshot.data.docs[index]["chatroomId"]);
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    print(Constants.myName);
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 40.0,
        ),
        actions: [
          GestureDetector(
            onTap: () async{
              await HelperFunctions.saveUserLoggedInSharedPreference(false);
              await authMethods.signOut();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: chatRoomStream == null ? Container() : chatRoomList()),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String otherUserName;
  final String chatRoomId;
  ChatRoomsTile(this.otherUserName, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(chatRoomId)));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text("${otherUserName.substring(0, 1).toUpperCase()}",
                  style: normalTextStyle()),
            ),
            SizedBox(width: 8),
            Text(
              otherUserName,
              style: normalTextStyle(),
            )
          ],
        ),
      ),
    );
  }
}
