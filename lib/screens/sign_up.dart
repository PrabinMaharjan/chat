// import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/screens/sign_in.dart';
import 'package:chat_app/services/authentication.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  final formKey = GlobalKey<FormState>();

  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  register() {
    if (formKey.currentState.validate()) {

      Map<String, String> userInfoMap ={
        "name" : userNameTextEditingController.text,
        "email" : emailTextEditingController.text,
      };

      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);
      setState(() {
        isLoading = true;
      });

      authMethods.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((value) {
        print(value);
      });



      databaseMethods.uploadUserInfo(userInfoMap);
      userNameTextEditingController.clear();
      emailTextEditingController.clear();
      passwordTextEditingController.clear();
       Navigator.pushReplacement(context, MaterialPageRoute(
           builder: (context) => SignIn()));
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
                                return value.isEmpty || value.length < 6
                                    ? "Enter valid user nama"
                                    : null;
                              },
                              controller: userNameTextEditingController,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("user name"),
                            ),
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
                      SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () {
                          register();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color(0xff007ef4),
                                Color(0xff2a75bc)
                              ]),
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            "Sign UP",
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
                          "Sign Up with Google",
                          style: boldTextStyle(Colors.black54),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have account? ",
                            style: normalTextStyle(),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (context) => SignIn()));

                              },
                              child: Text(
                                "Login",
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
    userNameTextEditingController.dispose();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
  }
}
