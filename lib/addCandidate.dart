import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class addCandidate extends StatefulWidget {
  addCandidate({Key? key}) : super(key: key);

  @override
  State<addCandidate> createState() => _addCandidateState();
}

class _addCandidateState extends State<addCandidate> {
  TextEditingController matricNumber = TextEditingController();

  var firebasefirestore = FirebaseFirestore.instance;

  List<TextFormField> textFormFields = [];

  List<TextEditingController> controllers = [];

  List<String> manifestoes = [];
  List<String> voters = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text("REGISTER A CANDIDATE")),
        backgroundColor: const Color.fromARGB(255, 0, 81, 146),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: matricNumber,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  width: 3,
                                  color: Colors.blue,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                )),
                            hintText: "Matric Number",
                            hintStyle: const TextStyle(color: Colors.black)),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: textFormFields.length + 1,
                          itemBuilder: (context, index) {
                            if (index == textFormFields.length) {
                              return ElevatedButton(
                                  onPressed: () {
                                    var controller = TextEditingController();
                                    controllers.add(controller);
                                    textFormFields.add(TextFormField(
                                      controller: controller,
                                      decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: const BorderSide(
                                                width: 3,
                                                color: Colors.blue,
                                              )),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: const BorderSide(
                                                color: Colors.black,
                                              )),
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                controllers.removeAt(index);
                                                textFormFields.removeAt(index);
                                                setState(() {});
                                              },
                                              icon: const Icon(Icons.delete))),
                                    ));
                                    setState(() {});
                                  },
                                  child: const Text("tambah form"));
                            }
                            return textFormFields[index];
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  var data = await checkStudent();
                  if (data) {
                    var data1 = await checkCandidate();
                    if (data1) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                                title: Text("Candidate Already Registered"));
                          });
                    } else {
                      registerCandidate();
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                                title: Text("Candidate Added"));
                          });
                    }
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            title: Text("Student Data is Non-Existant"),
                          );
                        });
                  }
                },
                child: const Text(
                  "Add Candidate",
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

  Future<bool> checkStudent() async {
    var data = await FirebaseFirestore.instance
        .collection("student")
        .where("matricNo", isEqualTo: matricNumber.text.toLowerCase())
        .get();
    if (data.docs.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<bool> checkCandidate() async {
    var data = await FirebaseFirestore.instance
        .collection("candidate")
        .where("matricNumber", isEqualTo: matricNumber.text.toLowerCase())
        .get();
    if (data.docs.isNotEmpty) {
      return true;
    }
    return false;
  }

  registerCandidate() {
    //retrieve the data from firebase doc student

    for (var element in controllers) {
      manifestoes.add(element.text);
    }
    FirebaseFirestore.instance
        .collection("student")
        .where("matricNo", isEqualTo: matricNumber.text.trim().toLowerCase())
        .get()
        .then((value) {
      //add the data to firebase document candidate
      var data = value.docs.first.data();
      FirebaseFirestore.instance.collection("candidate").add({
        "matricNumber": matricNumber.text.trim().toLowerCase(),
        "fullName": data["fullName"],
        "faculty": data["faculty"],
        "manifestoes": manifestoes,
        "voter": voters,
      });
    });
  }
}
