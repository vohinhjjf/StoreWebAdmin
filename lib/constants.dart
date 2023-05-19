import 'package:flutter/material.dart';

const mText = Color.fromARGB(225,0, 0, 128);
const mTitleColor = Colors.black;
const kVendorDetailsTextStyle = TextStyle(
    fontWeight: FontWeight.bold
);

class FirestoreConstants {
  static const pathUserCollection = "Users";
  static const pathMessageCollection = "messages";
  static const name = "name";
  static const id = "id";
  static const email = "email";
  static const chattingWith = "chattingWith";
  static const idFrom = "idFrom";
  static const idTo = "idTo";
  static const timestamp = "timestamp";
  static const content = "content";
  static const type = "type";
}