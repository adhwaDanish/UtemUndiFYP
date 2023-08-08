import 'dart:developer';

import 'package:UTeMUNDI/authstateScreen.dart';
import 'package:UTeMUNDI/homepage.dart';
import 'package:UTeMUNDI/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Register",
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 81, 146),
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: emailController,
                    style: TextStyle(color: Color.fromARGB(255, 0, 81, 146)),
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              width: 3,
                              color: Color.fromARGB(255, 0, 81, 146),
                            )),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 0, 81, 146),
                            )),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 0, 81, 146),
                            )),
                        hintText: "email",
                        hintStyle:
                            TextStyle(color: Color.fromARGB(255, 0, 81, 146))),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    style: TextStyle(color: Color.fromARGB(255, 0, 81, 146)),
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              width: 3,
                              color: Color.fromARGB(255, 0, 81, 146),
                            )),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 0, 81, 146),
                            )),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 0, 81, 146),
                            )),
                        hintText: "password",
                        hintStyle:
                            TextStyle(color: Color.fromARGB(255, 0, 81, 146))),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            var registered = await checkUser();
                            if (registered) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: Text(
                                            "The email you entered already has an existing account"));
                                  });
                            } else {
                              if (emailController.text == "" ||
                                  passwordController.text == "") {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          title:
                                              Text("Please Fill in the Form"));
                                    });
                              } else {
                                var data = await checkStudent();
                                if (data) {
                                  register();
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            title: Text(
                                                "Successfully Registered"));
                                      });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("You are not a student"),
                                        );
                                      });
                                }
                              }
                            }
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 0, 81, 146)),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Already have an account",
                    style: TextStyle(color: Color.fromARGB(255, 0, 81, 146)),
                  ),
                  TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyHomePage() /* letak new page*/)),
                      child: Text(
                        "SignIn",
                        style: TextStyle(color: Colors.red),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> checkStudent() async {
    var data = await FirebaseFirestore.instance
        .collection("student")
        .where("email", isEqualTo: emailController.text)
        .get();
    if (data.docs.length != 0) {
      return true;
    }
    return false;
  }

  Future<bool> checkUser() async {
    var data = await FirebaseFirestore.instance
        .collection("user")
        .where("email", isEqualTo: emailController.text)
        .get();
    if (data.docs.length != 0) {
      return true;
    }
    return false;
  }

  register() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((value) {
      if (value.user != null) {
        FirebaseFirestore.instance.collection("user").doc(value.user!.uid).set({
          "email": emailController.text.trim().toLowerCase(),
          "password": passwordController.text,
          "urlImg": "",
          "role": "student"
        });
      }
    });
  }
}
