import 'dart:developer';

import 'package:UTeMUNDI/navigationbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:UTeMUNDI/navigationbar.dart';
import 'package:UTeMUNDI/main.dart';

class AuthStateScreen extends StatefulWidget {
  const AuthStateScreen({Key? key}) : super(key: key);

  @override
  State<AuthStateScreen> createState() => _AuthStateScreenState();
}

class _AuthStateScreenState extends State<AuthStateScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BotNavBar();
          } else {
            return MainScreen();
          }
          return Container();
        });
  }
}
