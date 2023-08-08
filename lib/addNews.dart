// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class addNews extends StatelessWidget {
  addNews({Key? key}) : super(key: key);

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("ADD NEWS")),
        backgroundColor: Color.fromARGB(255, 0, 81, 146),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Spacer(),
              Container(
                decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: title,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  width: 3,
                                  color: Colors.blue,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )),
                            hintText: "News Title",
                            hintStyle: TextStyle(color: Colors.black)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: content,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  width: 3,
                                  color: Colors.blue,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )),
                            hintText: "News Content",
                            hintStyle: TextStyle(color: Colors.black)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  if (title.text == "" || content.text == "") {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              title: Text("Please Fill in the form"));
                        });
                  } else {
                    addNewsToFirebase();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(title: Text("News Added"));
                        });
                  }
                },
                child: Text(
                  "Add News",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    fixedSize: const Size(200, 70),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
              )
            ],
          ),
        ),
      ),
    );
  }

  addNewsToFirebase() {
    FirebaseFirestore.instance.collection("news").add({
      "newsTitle": title.text,
      "newsContent": content.text,
    });
  }
}
