import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Image.asset("assets/images/logo.png",height: 40,),
    );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.white54,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white54),
      ));
}

TextStyle simpleTextStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 16,
  );
}

TextStyle normalTextStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 18,
  );
}
TextStyle underlinedTextStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 18,
    decoration: TextDecoration.underline,
  );
}

TextStyle boldTextStyle(Color color) {
  return TextStyle(
    color: color,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
}