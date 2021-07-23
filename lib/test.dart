import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/CLubList.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final fb = FirebaseDatabase.instance.reference().child("ClubList").child("Club").child("ClubListName");


  @override
  void initState() {
    super.initState();
    fb.once().then((DataSnapshot snap){
      var data = snap.value;
      //list.clear();
      //data.forEach()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
