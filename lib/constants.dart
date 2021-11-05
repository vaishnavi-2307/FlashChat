import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Color(0xff00EDB3),
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  hintStyle: TextStyle(
    color: Colors.white,
  ),
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);
const kTextFieldDecoration =
//    InputDecoration(hintText: '', hintStyle: TextStyle(color: Colors.black38));
    InputDecoration(
  hintText: 'Enter your email',
  hintStyle: TextStyle(
    color: Colors.white,
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff00EDB3), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff00EDB3), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
