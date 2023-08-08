import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({Key? key}) : super(key: key);

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController password = TextEditingController();
  String profileImage = "";
  final ImagePicker _picker = ImagePicker();
  bool edit = true;
  File? img;
  @override
  Widget build(BuildContext context) {
    UploadTask uploadTask;
    var urlDownload;
    var id = FirebaseAuth.instance.currentUser!.uid;

    final docRef = FirebaseFirestore.instance.collection('user').doc(id);
    docRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;

      var sEmail = data['email'];
      profileImage = data['urlImg'];
      setState(() {});
      FirebaseFirestore.instance
          .collection("student")
          .where("email", isEqualTo: sEmail.trim().toLowerCase())
          .get()
          .then((value) {
        var hehe = value.docs.first.data();
        fullName.text = hehe['fullName'];
        emailController.text = hehe['email'];
      });
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[400],
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Profile Page",
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 81, 146),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Stack(
                  children: [
                    profileImage == null
                        ? CircleAvatar(
                            radius: 130,
                          )
                        : CircleAvatar(
                            radius: 130,
                            backgroundImage: Image.network(profileImage).image,
                          ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: FloatingActionButton(
                          backgroundColor: Color.fromARGB(255, 99, 185, 255),
                          child: Icon(Icons.edit),
                          onPressed: () async {
                            final XFile? image = await _picker.pickImage(
                                source: ImageSource.gallery);
                            final path = 'images/${image!.name}';
                            final file = File(image.path);

                            //access the Firebase Storage using the declared path
                            final ref =
                                FirebaseStorage.instance.ref().child(path);
                            //upload the file
                            uploadTask = ref.putFile(file);

                            //wait the upload to complete
                            final snapshot =
                                await uploadTask.whenComplete(() {});
                            //get the url link
                            urlDownload = await snapshot.ref.getDownloadURL();

                            FirebaseFirestore.instance
                                .collection('user')
                                .doc(id)
                                .get()
                                .then((value) {
                              var data = value.data();
                              FirebaseFirestore.instance
                                  .collection("user")
                                  .doc(id)
                                  .update({"urlImg": urlDownload});
                            });

                            if (image != null) {
                              img = File(image.path);
                            }

                            setState(() {});
                          }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 70,
                ),
                Container(
                  width: 400,
                  height: 493,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                edit = !edit;
                              });
                            },
                            child: edit
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                      ),
                                      Text(
                                        "Edit",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.cancel),
                                      Text("cancel"),
                                    ],
                                  ),
                          ),
                          TextFormField(
                            controller: emailController,
                            readOnly: edit,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.black,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: fullName,
                            readOnly: edit,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.black,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: password,
                            readOnly: edit,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.black,
                                    )),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    )),
                                hintText: "Password",
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 0, 81, 146))),
                          ),
                          Visibility(
                              visible: !edit,
                              child: ElevatedButton(
                                  onPressed: () {
                                    updateProfile();
                                  },
                                  child: Text("Save")))
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  updateProfile() {
    var id = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('user').doc(id).get().then((value) {
      var data = value.data();

      FirebaseFirestore.instance
          .collection("user")
          .doc(id)
          .update({"password": password.text});
    });
  }
}
