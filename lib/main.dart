import 'dart:developer';

import 'package:UTeMUNDI/adminMainPage.dart';
import 'package:UTeMUNDI/homepage.dart';
import 'package:UTeMUNDI/navigationbar.dart';
import 'package:UTeMUNDI/profilepage.dart';
import 'package:UTeMUNDI/splashScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:local_auth/local_auth.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:UTeMUNDI/navigationbar.dart';
import 'package:UTeMUNDI/register.dart';
import 'package:UTeMUNDI/swipe.dart';

//listview.builder

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: splashScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final controller = PageController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool obsecure = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var firebasefirestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MyHomePage();
        }));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MyHomePage();
        }));
      }

      log(result.toString());

      // Got a new connectivity status!
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                width: double.infinity,
                padding: const EdgeInsets.all(10.0),
                height: 200,
                child: Image.asset("assets/images/logoUtem.png"),
              ),
              SizedBox(
                height: 80,
              ),
              Center(
                  child: Text(
                "Welcome To UTeMUNDI",
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 81, 146),
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              )),
              SizedBox(
                height: 30,
              ),

              //SizedBox(height: 90,),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    hintText: "email",
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 0, 81, 146)),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 0, 81, 146)),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 0, 81, 146)),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 0, 81, 146), width: 3),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 0, 81, 146),
                    )),
                style: TextStyle(color: Color.fromARGB(255, 0, 81, 146)),
              ),
              SizedBox(
                height: 10,
              ),

              TextFormField(
                controller: passwordController,
                obscureText: obsecure,
                decoration: InputDecoration(
                    hintText: "password",
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 0, 81, 146)),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 0, 81, 146)),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 0, 81, 146)),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 0, 81, 146), width: 3),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Color.fromARGB(255, 0, 81, 146),
                    ),
                    suffix: GestureDetector(
                      onTap: () {
                        obsecure = !obsecure;
                        setState(() {});
                      },
                      child: Icon(
                        Icons.remove_red_eye,
                        color: Color.fromARGB(255, 0, 81, 146),
                      ),
                    )),
                style: TextStyle(color: Color.fromARGB(255, 0, 81, 146)),
              ),

              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Color.fromARGB(255, 0, 81, 146)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Register() /* letak new page*/));
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),

              ElevatedButton(
                onPressed: () {
                  login();
                  //
                  //add login function
                },
                child: Text(
                  "Sign In",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 0, 81, 146),
                    fixedSize: Size(500, double.infinity)),
              )
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) async {
        if (value.user != null) {
          var dc = await FirebaseFirestore.instance
              .collection('user')
              .doc(value.user!.uid)
              .get();
          if (dc.exists) {
            if (dc.get("role") == "admin") {
              //admin page
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          adminMainPage() /* letak new page*/));
            } else {
              //student page
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BotNavBar() /* letak new page*/));
            }
          }
        }
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    } catch (e) {
      print(e.toString());
    }
  }
}
