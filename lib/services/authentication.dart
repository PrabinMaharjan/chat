import 'package:chat_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart'as auth;

class AuthMethods{

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  User _userFromFirebaseUser(auth.User user){
    return user !=null ?User(uid: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      auth.UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      auth.User user = result.user;
      return _userFromFirebaseUser(user);

    }catch(e){
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async{
    try{
      auth.UserCredential  result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      auth.User user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
    }
  }

  Future resetPassword(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }

  Future signOut() async{
    try{
      print('signing out');
      await _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }

}