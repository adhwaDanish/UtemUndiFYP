import 'package:flutter/material.dart';

class doneVote extends StatefulWidget {
  const doneVote({Key? key}) : super(key: key);

  @override
  State<doneVote> createState() => _doneVoteState();
}

class _doneVoteState extends State<doneVote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 81, 146),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "You have voted already",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
