import 'package:UTeMUNDI/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'adminMainPage.dart';
import 'navigationbar.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    return Scaffold(
        body: Center(
      child: Image.asset("assets/images/adhwa.png"),
    ));
  }

  getUser() async {
    if (FirebaseAuth.instance.currentUser != null) {
      var dc = await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      await Future.delayed(Duration(milliseconds: 2000));
      if (dc.exists) {
        if (dc.get("role") == "admin") {
          //admin page
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => adminMainPage() /* letak new page*/));
        } else {
          //student page
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BotNavBar() /* letak new page*/));
        }
      }
    } else {
      await Future.delayed(Duration(milliseconds: 2000));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen() /* letak new page*/));
    }
  }
}
