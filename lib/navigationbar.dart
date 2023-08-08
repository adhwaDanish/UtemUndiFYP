//import 'dart:html';

import 'package:UTeMUNDI/homepage.dart';
import 'package:UTeMUNDI/main.dart';
import 'package:UTeMUNDI/profilepage.dart';
import 'package:UTeMUNDI/votepage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BotNavBar extends StatefulWidget {
  BotNavBar({Key? key}) : super(key: key);

  @override
  State<BotNavBar> createState() => _BotNavBarState();
}

class _BotNavBarState extends State<BotNavBar> {
  int index = 1;
  PageController pageController = PageController(initialPage: 1);
  final screens = [
    Votepage(),
    Homepage(),
    Profilepage(),
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(
        Icons.where_to_vote,
        size: 30,
        color: Colors.white,
      ),
      Icon(Icons.home, size: 30, color: Colors.white),
      Icon(Icons.person, size: 30, color: Colors.white),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: CurvedNavigationBar(
          animationDuration: Duration(milliseconds: 350),
          color: Color.fromARGB(255, 0, 81, 146),
          buttonBackgroundColor: Color.fromARGB(255, 0, 81, 146),
          backgroundColor: Colors.transparent,
          height: 60,
          items: items,
          index: index,
          onTap: (index) {
            setState(() => this.index = index);
            pageController.animateToPage(index,
                duration: Duration(milliseconds: 350), curve: Curves.easeIn);
          },
        ),
        body: PageView(
          onPageChanged: (value) {
            setState(() => this.index = value);
          },
          children: screens,
          controller: pageController,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey,
          child: Icon(
            Icons.logout,
            color: Colors.white,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Are you sure you want to logout?"),
                    content: Row(children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("cancel")),
                      ElevatedButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()));
                          },
                          child: Text("Confirm"))
                    ]),
                  );
                });
          },
        ),
      ),
    );
  }
}
