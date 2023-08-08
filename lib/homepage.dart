import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  var data = [2, 3, 4, 5];
  var image;
  int i = 1;
  List<dynamic> manifestoes = [];
  TabController? tabController;

  @override
  Widget build(BuildContext context) {
    if (tabController == null) {
      tabController = TabController(length: 2, vsync: this);
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              height: 200,
              color: Colors.grey[100],
              child: Image.asset("assets/images/logoUtem.png"),
            ),
            TabBar(
                controller: tabController,
                labelColor: Color.fromARGB(255, 0, 81, 146),
                indicatorColor: Color.fromARGB(255, 0, 81, 146),
                tabs: [
                  Tab(text: "candidates"),
                  Tab(
                    text: "recent news",
                  )
                ]),
            Expanded(
              child: Container(
                width: double.infinity,
                child: TabBarView(controller: tabController, children: [
                  //listView for candidate
                  FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      future: FirebaseFirestore.instance
                          .collection("candidate")
                          .get(),
                      builder: (context, data) {
                        if (data.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (data.hasData) {
                          return ListView.builder(
                              itemCount: data.data!.docs.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    // print("hehe");
                                    final docRef = FirebaseFirestore.instance
                                        .collection('candidate')
                                        .doc(data.data!.docs[index].id);
                                    docRef
                                        .get()
                                        .then((DocumentSnapshot doc) async {
                                      final cand =
                                          doc.data() as Map<String, dynamic>;
                                      //add list
                                      //
                                      //
                                      var matricNumber = cand['matricNumber'];
                                      manifestoes = cand['manifestoes'];
                                      log(manifestoes.toString());
                                      FirebaseFirestore.instance
                                          .collection("student")
                                          .where("matricNo",
                                              isEqualTo: matricNumber)
                                          .get()
                                          .then(
                                        (value) async {
                                          var hehe = value.docs.first.data();
                                          var email = hehe['email'];
                                          FirebaseFirestore.instance
                                              .collection("user")
                                              .where("email", isEqualTo: email)
                                              .get()
                                              .then((value1) {
                                            var hehe1 =
                                                value1.docs.first.data();
                                            image = hehe1['urlImg'];
                                            log(image);
                                            setState(() {});
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                      child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 130,
                                                        backgroundImage:
                                                            Image.network(image)
                                                                .image,
                                                      ),
                                                      Table(
                                                          border: TableBorder.all(
                                                              color:
                                                                  Colors.black,
                                                              style: BorderStyle
                                                                  .solid,
                                                              width: 2),
                                                          children: [
                                                            TableRow(children: [
                                                              Column(children: [
                                                                Text(
                                                                    'Full Name')
                                                              ]),
                                                              Column(
                                                                  children: [
                                                                    Text(data
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        'fullName'])
                                                                  ]),
                                                            ]),
                                                            TableRow(children: [
                                                              Column(children: [
                                                                Text(
                                                                    'Matric Number')
                                                              ]),
                                                              Column(
                                                                  children: [
                                                                    Text(data
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        'matricNumber'])
                                                                  ]),
                                                            ]),
                                                          ]),
                                                      ...manifestoes.map((e) {
                                                        return Text(
                                                            "maniefesto  :$e");
                                                      })
                                                    ],
                                                  ));
                                                });
                                          });
                                        },
                                      );
                                    });
                                  },
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      elevation: 5,
                                      margin: EdgeInsets.all(10),
                                      color: Color.fromARGB(255, 0, 81, 146),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          data.data!.docs[index]["fullName"],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )),
                                );
                              });
                        }
                        return SizedBox();
                      }),
                  //listView for news
                  FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: FirebaseFirestore.instance.collection("news").get(),
                    builder: (context, news) {
                      print(news.data);
                      if (news.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (news.hasData) {
                        return ListView.builder(
                            itemCount: news.data!.docs.length,
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: () {
                                  var uid = news.data!.docs[i]['newsContent'];

                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(uid),
                                        );
                                      });
                                },
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    elevation: 5,
                                    margin: EdgeInsets.all(10),
                                    color: Color.fromARGB(255, 99, 185, 255),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        news.data!.docs[i]["newsTitle"],
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )),
                              );
                            });
                      }
                      return SizedBox();
                    },
                  )
                ]),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
