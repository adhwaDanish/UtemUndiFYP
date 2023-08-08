import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class scheduleVoting extends StatefulWidget {
  const scheduleVoting({Key? key}) : super(key: key);

  @override
  State<scheduleVoting> createState() => _scheduleVotingState();
}

class _scheduleVotingState extends State<scheduleVoting> {
  DateTime? date;
  TimeOfDay? time; //time
  TimeOfDay? time1;
  var timeC;
  var timeC1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("SCHEDULE VOTING")),
        backgroundColor: Color.fromARGB(255, 0, 81, 146),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              height: 35,
                              child: Text("Date",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size.fromHeight(40),
                                primary: Colors.black),
                            child: Text(getText()),
                            onPressed: () {
                              pickDate(context);
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              height: 35,
                              child: Text("Start Time",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size.fromHeight(40),
                                primary: Colors.black),
                            child: Text(getTextTime()),
                            onPressed: () {
                              pickTime(context);
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              height: 35,
                              child: Text("End Time",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size.fromHeight(40),
                                primary: Colors.black),
                            child: Text(getTextTime1()),
                            onPressed: () {
                              pickTime1(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      fixedSize: const Size(200, 70),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  onPressed: () {
                    checkTime();
                  },
                  child: Text("Submit")),
            ],
          ),
        ),
      ),
    );
  }

  addScheduleToFirebase() async {
    var check = await checkSchedule();
    if (check == true) {
      var data = await FirebaseFirestore.instance.collection("schedule").get();
      var id = data.docs.first.id;
      FirebaseFirestore.instance.collection("schedule").doc(id).update({
        'date': '${date?.month}/${date?.day}/${date?.year}',
        'day': date!.day,
        'month': date!.month,
        'year': date!.year,
        'startTime': timeC,
        'endTime': timeC1
      });
    } else {
      FirebaseFirestore.instance.collection("schedule").add({
        'date': '${date!.month}/${date!.day}/${date!.year}',
        'day': date!.day,
        'month': date!.month,
        'year': date!.year,
        'startTime': timeC,
        'endTime': timeC1
      });
    }
  }

  Future<bool> checkSchedule() async {
    var data = await FirebaseFirestore.instance.collection("schedule").get();
    if (data.docs.length != 0) {
      return true;
    }
    return false;
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    print(initialDate);
    final newDate = await showDatePicker(
        context: context,
        initialDate: date ?? initialDate,
        firstDate: DateTime(DateTime.now().day - 1),
        selectableDayPredicate: (date) {
          if (date.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
            return false;
          }
          return true;
        },
        lastDate: DateTime(DateTime.now().year + 1));
    if (newDate == null) {
      return;
    } else {
      setState(() => date = newDate);
    }
  }

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 8, minute: 0);
    final newTime = await showTimePicker(
        context: context, initialTime: time ?? initialTime);

    if (newTime == null) {
      return;
    } else {
      setState(() => time = newTime);
    }
  }

  Future pickTime1(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 8, minute: 0);
    final newTime = await showTimePicker(
        context: context, initialTime: time1 ?? initialTime);

    if (newTime == null) {
      return;
    } else {
      setState(() => time1 = newTime);
    }
  }

  String getTextTime1() {
    if (time1 == null) {
      return 'select End Time';
    } else {
      final hours = time1?.hour.toString().padLeft(2, '0');
      final minutes = time1?.minute.toString().padLeft(2, '0');
      timeC1 = '${hours}:${minutes}';
      return timeC1;
    }
  }

  String getText() {
    if (date == null) {
      return 'select date';
    } else {
      return '${date?.month}/${date?.day}/${date?.year}';
    }
  }

  String getTextTime() {
    if (time == null) {
      return 'select Start Time';
    } else {
      final hours = time?.hour.toString().padLeft(2, '0');
      final minutes = time?.minute.toString().padLeft(2, '0');
      timeC = '${hours}:${minutes}';
      return timeC;
    }
  }

  void checkTime() {
    if (time!.hour > time1!.hour) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("make sure start time is less than end time"),
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Succesfully schedule voting"),
            );
          });
      addScheduleToFirebase();
    }
  }
}
