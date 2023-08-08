import 'dart:developer';

import 'package:UTeMUNDI/addCandidate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class manageCandidate extends StatefulWidget {
  const manageCandidate({Key? key}) : super(key: key);

  @override
  State<manageCandidate> createState() => _manageCandidateState();
}

class _manageCandidateState extends State<manageCandidate> {
  var image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.yellow,
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => addCandidate() /* letak new page*/));
          }),
      appBar: AppBar(
        title: Text("MANAGE CANDIDATE"),
      ),
      backgroundColor: Colors.blue,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream:
              FirebaseFirestore.instance.collection("candidate").snapshots(),
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
                        final docRef = FirebaseFirestore.instance
                            .collection('candidate')
                            .doc(data.data!.docs[index].id);
                        docRef.get().then((DocumentSnapshot doc) async {
                          final cand = doc.data() as Map<String, dynamic>;

                          var matricNumber = cand['matricNumber'];
                          await FirebaseFirestore.instance
                              .collection("student")
                              .where("matricNo", isEqualTo: matricNumber)
                              .get()
                              .then(
                            (value) async {
                              var hehe = value.docs.first.data();
                              var email = hehe['email'];
                              await FirebaseFirestore.instance
                                  .collection("user")
                                  .where("email", isEqualTo: email)
                                  .get()
                                  .then((value1) {
                                var hehe1 = value1.docs.first.data();
                                image = hehe1['urlImg'];
                                log(image);
                                setState(() {});
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                          child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircleAvatar(
                                            radius: 130,
                                            backgroundImage:
                                                Image.network(image).image,
                                          ),
                                          Table(
                                              border: TableBorder.all(
                                                  color: Colors.black,
                                                  style: BorderStyle.solid,
                                                  width: 2),
                                              children: [
                                                TableRow(children: [
                                                  Column(children: [
                                                    Text('Full Name')
                                                  ]),
                                                  Column(children: [
                                                    Text(data.data!.docs[index]
                                                        ['fullName'])
                                                  ]),
                                                ]),
                                                TableRow(children: [
                                                  Column(children: [
                                                    Text('Matric Number')
                                                  ]),
                                                  Column(children: [
                                                    Text(data.data!.docs[index]
                                                        ['matricNumber'])
                                                  ]),
                                                ]),
                                                TableRow(children: [
                                                  Column(children: [
                                                    Text('manifesto 1')
                                                  ]),
                                                  Column(children: [
                                                    Text(data.data!.docs[index]
                                                        ['manifesto1'])
                                                  ]),
                                                ]),
                                                TableRow(children: [
                                                  Column(children: [
                                                    Text('manifesto 2')
                                                  ]),
                                                  Column(children: [
                                                    Text(data.data!.docs[index]
                                                        ['manifesto2'])
                                                  ]),
                                                ])
                                              ]),
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
                              borderRadius: BorderRadius.circular(10.0)),
                          elevation: 5,
                          margin: EdgeInsets.all(10),
                          color: Colors.yellow,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    data.data!.docs[index]["fullName"],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  "Are you sure you want to delete this candidate?"),
                                              content: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("cancel")),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          deleteCandidate(data
                                                              .data!
                                                              .docs[index]
                                                              .id);
                                                        },
                                                        child: Text("Confirm"))
                                                  ]),
                                            );
                                          });
                                    },
                                    icon: Icon(Icons.delete)),
                              ],
                            ),
                          )),
                    );
                  });
            }
            return SizedBox();
          }),
    );
  }

  deleteCandidate(matricNumber) {
    //retrieve the data from firebase doc student

    FirebaseFirestore.instance
        .collection("candidate")
        .doc(matricNumber)
        .delete()
        .then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error updating document $e"),
        );
  }
}
