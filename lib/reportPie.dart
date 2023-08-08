import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'indicator.dart';

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  int touchedIndex = -1;

  double dahVote = 0;
  double belumVote = 0;
  double dahPercent = 0;
  double belumPercent = 0;
  double dudukLuar = 0;
  double dudukDalam = 0;
  double male = 0;
  double maleVoted = 0;
  double malePercentage = 0;
  double female = 0;
  double femaleVoted = 0;
  double femalePercentage = 0;
  void initState() {
    super.initState();
    setup();
    print(dahPercent);
    print(belumPercent);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Card(
              color: Colors.grey[200],
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    height: 18,
                  ),
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                            pieTouchData: PieTouchData(touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            }),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: 40,
                            sections: showingSections()),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Indicator(
                        color: Color.fromARGB(255, 0, 255, 8),
                        text: 'Voted',
                        textColor: Colors.black,
                        isSquare: true,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Indicator(
                        color: Colors.red,
                        text: 'Has not voted',
                        textColor: Colors.black,
                        isSquare: true,
                      ),
                      SizedBox(
                        height: 18,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 28,
                  ),
                ],
              ),
            ),
            Card(
              color: Colors.grey[250],
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("total male : $male")],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("total male has not voted : " +
                            malePercentage.toStringAsFixed(2))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("total female : $female")],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("total female  has not voted : " +
                            femalePercentage.toStringAsFixed(2))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("total college student has not voted : " +
                            dudukDalam.toStringAsFixed(2))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("total remote student has not voted : " +
                            dudukLuar.toStringAsFixed(2))
                      ],
                    ),
                  ]),
            ),
            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future:
                    FirebaseFirestore.instance.collection("candidate").get(),
                builder: (context, data) {
                  if (data.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (data.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              elevation: 5,
                              margin: EdgeInsets.all(10),
                              color: Color.fromARGB(255, 0, 81, 146),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data.data!.docs[index]["fullName"],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Text(
                                        "vote counts:${(data.data!.docs[index]["voter"] as List).length.toString()}",
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ));
                        });
                  }
                  return SizedBox();
                })
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Color.fromARGB(255, 0, 255, 8),
            value: dahVote.toDouble(),
            title: dahPercent.toStringAsFixed(2) + "%",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: belumVote.toDouble(),
            title: belumPercent.toStringAsFixed(2) + "%",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          );

        default:
          throw Error();
      }
    });
  }

  setup() {
    //calculating voted and has not voted percentage
    FirebaseFirestore.instance
        .collection('student')
        .where("voteStatus", isEqualTo: true)
        .get()
        .then((value) {
      dahVote = (value.docs.length).toDouble();
    });
    print(dahVote);
    FirebaseFirestore.instance
        .collection('student')
        .where("voteStatus", isEqualTo: false)
        .get()
        .then((value) {
      belumVote = value.docs.length.toDouble();
      print(belumVote);
    });

//calculating college
    FirebaseFirestore.instance
        .collection('student')
        .where("college", isEqualTo: "satria")
        .get()
        .then((value) {
      dudukDalam = (value.docs.length).toDouble();
    });
    //print(dudukDalam);
    FirebaseFirestore.instance
        .collection('student')
        .where("college", isEqualTo: "")
        .get()
        .then((value) {
      dudukLuar = value.docs.length.toDouble();
      //print(dudukLuar);
    });

    //calculating gender
    FirebaseFirestore.instance
        .collection('student')
        .where("gender", isEqualTo: "male")
        .where("voteStatus", isEqualTo: true)
        .get()
        .then((value) {
      maleVoted = (value.docs.length).toDouble();
    });
    print(maleVoted);

    FirebaseFirestore.instance
        .collection('student')
        .where("gender", isEqualTo: "male")
        .get()
        .then((value) {
      male = (value.docs.length).toDouble();
    });
    print(male);

    FirebaseFirestore.instance
        .collection('student')
        .where("gender", isEqualTo: "female")
        .where("voteStatus", isEqualTo: true)
        .get()
        .then((value) {
      femaleVoted = value.docs.length.toDouble();
    });

    FirebaseFirestore.instance
        .collection('student')
        .where("gender", isEqualTo: "female")
        .get()
        .then((value) {
      female = value.docs.length.toDouble();
      print(female);

      setState(() {});

      //calculate percentage
      var totalmain = dahVote + belumVote;
      dahPercent = (dahVote / totalmain.toDouble()) * 100;
      print(dahPercent);
      belumPercent = (belumVote / totalmain.toDouble()) * 100;

      // calculate gender
      malePercentage = male - dahVote;
      femalePercentage = female - dahVote;
      var ddDlm = dudukDalam;
      var ddLuar = dudukLuar;
      dudukDalam = ddDlm - dahVote;
      dudukLuar = ddLuar - dahVote;
    });
    setState(() {});
  }

  void percentageDah() {}
}
