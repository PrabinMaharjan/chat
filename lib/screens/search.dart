import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/screens/conversation.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();

  TextEditingController _searchController = TextEditingController();

  QuerySnapshot searchSnapshot;

  @override
  void initState() {
    super.initState();
  }

  initiateSearch() async {
    await databaseMethods.getUserByName(_searchController.text).then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  Widget SearchTile({String userName, String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: simpleTextStyle(),
              ),
              Text(
                userEmail,
                style: simpleTextStyle(),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatRoomAndConversation(userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Message",
                style: boldTextStyle(Colors.white),),
            ),
          )
        ],
      ),
    );
  }

  
  createChatRoomAndConversation({String userName}){
    String chatRoomId = getChatRoomId(userName, Constants.myName);
    List<String> users = [userName, Constants.myName];
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatroomId": chatRoomId
    };


    databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(chatRoomId)));
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.docs.length,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapshot.docs[index]["name"],
                userEmail: searchSnapshot.docs[index]["email"],
              );
            })
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54ffff),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _searchController,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                        hintText: "search username...",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        border: InputBorder.none),
                  )),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0x36ffffff), Color(0x0fffffff)]),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(Icons.search)),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}



getChatRoomId(String a, String b){
  if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
    return"$b\_$a";
  }else{
    return "$a\_$b";
  }
}
