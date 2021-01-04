import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/screens/chat_room.dart';
import 'package:chat_app/screens/sign_up.dart';
import 'package:chat_app/services/authentication.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  // final Function toggle;
  SignIn();

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  signIn() async{
    if (formKey.currentState.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      await authMethods.signInWithEmailAndPassword(
          emailTextEditingController.text, passwordTextEditingController.text).then((value) async{
            if(value != null){
              HelperFunctions.saveUserLoggedInSharedPreference(true);
            }
      });
await databaseMethods.getUserByEmail(emailTextEditingController.text)
          .then((value){
        snapshotUserInfo = value;
        HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.docs[0]['name']);
        print("data contained in snapshot: $snapshotUserInfo");
      });

      setState(() {
        isLoading = true;
      });

      emailTextEditingController.clear();
      passwordTextEditingController.clear();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ChatRoom()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 50,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) {
                                return RegExp(
                                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                    .hasMatch(value)
                                    ? null
                                    : "Enter valid email";
                              },
                              controller: emailTextEditingController,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("email"),
                            ),
                            TextFormField(
                              obscureText: true,
                              validator: (value) {
                                return value.length < 6
                                    ? "Password must be atleast 6 characters"
                                    : null;
                              },
                              controller: passwordTextEditingController,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("password"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            "Forgot Password?",
                            style: normalTextStyle(),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      GestureDetector(
                        onTap: (){
                          signIn();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Color(0xff007ef4), Color(0xff2a75bc)]),
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            "Sign In",
                            style: boldTextStyle(Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          "Sign In with Google",
                          style: boldTextStyle(Colors.black54),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have account? ",
                            style: normalTextStyle(),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (context) => SignUp()));

                              },
                              child: Text(
                                "Register Now",
                                style: underlinedTextStyle(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
  }
}
