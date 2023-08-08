import 'package:UTeMUNDI/doneVote.dart';
import 'package:UTeMUNDI/register.dart';
import 'package:UTeMUNDI/votingStart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Votepage extends StatelessWidget {
  Votepage({Key? key}) : super(key: key);
  DateTime? date = DateTime.now();
  final initialDateMonth = DateTime.now().month;
  final initialDateDay = DateTime.now().day;
  final initialDateYear = DateTime.now().year;
  int? day;
  int? month;
  int? year;
  int? startTime;
  int? endTime;
  TimeOfDay? time = TimeOfDay.now();
  var id = FirebaseAuth.instance.currentUser!.uid;
  bool voteStatus = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color.fromARGB(255, 0, 81, 146),
          body: FutureBuilder<Widget>(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return snapshot.data!;
                print(startTime);
                print(endTime);
                print(time!.hour);
                print(day);
                print(month);
                print(year);
              })),
    );
  }

  Future<Widget> getData() async {
    var data = await FirebaseFirestore.instance
        .collection("schedule")
        .doc('KM4j1JbyGpLMOqVY1PiV')
        .get();
    day = data['day'];
    month = data['month'];
    year = data['year'];
    startTime = int.parse((data['startTime'] as String).substring(0, 2));
    endTime = int.parse((data['endTime'] as String).substring(0, 2));

    if (year! > initialDateYear || year! < initialDateYear) {
      return Text("It is not time for voting yet year",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold));
    } else {
      if (month! > initialDateMonth || month! < initialDateMonth) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("It is not time for voting yet month",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        );
      } else {
        if (day! > initialDateDay || day! < initialDateDay) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("It is not time for voting yet day",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          );
        } else {
          if (time!.hour < startTime! || time!.hour > endTime!) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("It is not time for voting yet hour",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            );
          } else {
            var cand = await FirebaseFirestore.instance
                .collection("user")
                .doc(id)
                .get();

            var value = await FirebaseFirestore.instance
                .collection("student")
                .where("email", isEqualTo: cand['email'])
                .get();
            var x = value.docs.first.data();
            voteStatus = x['voteStatus'];
            print(79);
            print(voteStatus);
            if (voteStatus) {
              return doneVote();
            } else {
              return votingStart();
            }
          }
        }
      }
    }
  }

  checkVoteDay() {
    var date = FirebaseFirestore.instance.collection('schedule').doc().get;
  }
}
