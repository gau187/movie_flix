import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

final Color primaryColor = Color(0xffE50914);
final Color bodyColor = Color(0xff222222);
final Color appBarColor = Color(0xff333333);
User user;

showToast(BuildContext context,String text){
  Toast.show(text, context,
      duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
}

Widget buildBtn(String text, Function onClick) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 25.0),
    width: double.infinity,
    child: RaisedButton(
      onPressed: () {
        onClick();
      },
      textColor: Colors.white,
      padding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      //elevation: 0.0,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Text(text,
            maxLines: 1,
            style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: 22.0,
                fontWeight: FontWeight.bold
            )),
      ),
    ),
  );
}