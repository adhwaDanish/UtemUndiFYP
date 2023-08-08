import 'package:UTeMUNDI/addCandidate.dart';
import 'package:UTeMUNDI/addNews.dart';
import 'package:UTeMUNDI/manageCandidate.dart';

import 'package:UTeMUNDI/reportPage.dart';
import 'package:UTeMUNDI/reportPie.dart';
import 'package:UTeMUNDI/scheduleVoting.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class adminMainPage extends StatelessWidget {
  const adminMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.logout),
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
            }),
        backgroundColor: Color.fromARGB(255, 0, 81, 146),
        body: SizedBox(
          width: double.maxFinite,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  height: 200,
                  color: Colors.lightBlue[100],
                  child: Image.asset("assets/images/logoUtem.png"),
                ),
                SizedBox(
                  height: 50,
                  child: Text(
                    "Welcome to Admin's Homepage",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Color.fromARGB(255, 0, 81, 146),
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                fixedSize: const Size(200, 70),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50))),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          manageCandidate() /* letak new page*/));
                            },
                            child: Text("Manage Candidate")),
                        SizedBox(
                          height: 5,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                fixedSize: const Size(200, 70),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50))),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          scheduleVoting() /* letak new page*/));
                            },
                            child: Text("Schedule Voting")),
                        SizedBox(
                          height: 5,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                fixedSize: const Size(200, 70),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50))),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          addNews() /* letak new page*/));
                            },
                            child: Text("Add News")),
                        SizedBox(
                          height: 5,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                fixedSize: const Size(200, 70),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50))),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PieChartSample2() /* letak new page*/));
                            },
                            child: Text("Statistical Report")),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
