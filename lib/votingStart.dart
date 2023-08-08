import 'dart:async';

import 'package:UTeMUNDI/doneVote.dart';
import 'package:UTeMUNDI/votepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import 'navigationbar.dart';

class votingStart extends StatefulWidget {
  const votingStart({Key? key}) : super(key: key);

  @override
  State<votingStart> createState() => _votingStartState();
}

class _votingStartState extends State<votingStart> {
// ···

  int count = 0;
  List abc = [];
  String title = "";
  bool loading = true;
  bool selecting = false;
  var id = FirebaseAuth.instance.currentUser!.uid;
  QuerySnapshot<Map<String, dynamic>>? candidate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    print(abc);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: abc.isNotEmpty ? Text(count.toString()) : null,
      ),
      backgroundColor: Colors.white,
      body: loading
          ? const CircularProgressIndicator()
          : Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: ListView.separated(
                      itemCount: candidate!.docs.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onLongPress: () {
                              selected(candidate!.docs[index].id);
                            },
                            onTap: () {
                              addOrRemove(candidate!.docs[index].id);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: abc.contains(candidate!.docs[index].id)
                                      ? Colors.red
                                      : Color.fromARGB(255, 0, 81, 146),
                                  borderRadius: BorderRadius.circular(20)),
                              child: ListTile(
                                  title: Text(
                                candidate!.docs[index]['fullName'],
                                style: TextStyle(color: Colors.white),
                              )),
                            ));
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 20,
                        );
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      //add fingerprint
                      int countVote = abc.length;

                      if (countVote != 1) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title:
                                    Text("Please Enter 1 person to vote only"),
                              );
                            });
                      } else {
                        print("line 99");
                        updateToFirebase();
                      }
                    },
                    child: Text("submit"))
              ],
            ),
    );
  }

  getData() async {
    candidate = await FirebaseFirestore.instance.collection("candidate").get();
    loading = false;
    setState(() {});
  }

  addOrRemove(String index) {
    if (abc.contains(index)) {
      count--;
      abc.remove(index);
    } else if (!abc.contains(index) && selecting) {
      count++;
      abc.add(index);
    }
    if (abc.isEmpty) {
      selecting = false;
    }
    setState(() {});
  }

  selected(String index) {
    if (!selecting) {
      if (!abc.contains(index)) {
        selecting = true;
        count++;

        abc.add(index);
        setState(() {});
      }
    }
  }

  updateToFirebase() async {
    print("line 142");
    print(abc.length);
    print(id);
    final LocalAuthentication auth = LocalAuthentication();
    // ···
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    var studentEmail;
    var studentE;
    var tempID;
    var user;
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      studentEmail = value['email'];
      //studentE = user['email'];
      print(studentEmail);
      if (availableBiometrics.isNotEmpty) {
        final bool didAuthenticate = await auth.authenticate(
            localizedReason: 'Please authenticate to submit vote');
        if (didAuthenticate) {
          for (var element in abc) {
            FirebaseFirestore.instance
                .collection('candidate')
                .doc(element)
                .update({
              "voter": FieldValue.arrayUnion([id]),
            });
          }

          FirebaseFirestore.instance
              .collection('student')
              .where("email", isEqualTo: studentEmail)
              .get()
              .then((value) => {
                    tempID = value.docs.first.id,
                    FirebaseFirestore.instance
                        .collection('student')
                        .doc(tempID)
                        .update({
                      "voteStatus": true,
                    })
                  });

          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Succesfully submitted vote"),
                );
              });
          Timer(Duration(seconds: 3), () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => BotNavBar()));
          });
        }
      }
    });
    print("160");
  }
}
