import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_flix/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  navigate() async {
    user = FirebaseAuth.instance.currentUser;
    Future.delayed(Duration(seconds: 2),(){
      if(user!=null){
        Navigator.popAndPushNamed(context,"/home");
      }else{
        Navigator.popAndPushNamed(context,"/login");
      }
    });
  }

  @override
  void initState() {
    navigate();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: bodyColor,
      body: Container(
        height: h,
        width: w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("MF",style: TextStyle(color: primaryColor,fontSize: h/6,fontWeight: FontWeight.bold)),
            Text("MovieFlix",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
