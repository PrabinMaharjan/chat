// import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/screens/chat_room.dart';
import 'package:chat_app/screens/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145c9e),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
       primarySwatch: Colors.blue,
       visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _buildHomeScreen(context),
    );
  }
}
Widget _buildHomeScreen(BuildContext context) {
  return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User> snapshot) {
        if(snapshot.hasData) {
          return ChatRoom();
        }
        return SignIn();
      }
  );
  FirebaseAuth.instance
      .authStateChanges()
      .listen((User user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
}
