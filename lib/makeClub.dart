import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'UserAccount.dart';

class MakeClub extends StatefulWidget {
  const MakeClub({Key? key}) : super(key: key);

  @override
  _MakeClubState createState() => _MakeClubState();
}

class _MakeClubState extends State<MakeClub> {
  final formKey = new GlobalKey<FormState>();
  var currentUser = FirebaseAuth.instance.currentUser;

  final DatabaseReference fb = new FirebaseDatabase().reference().child("ClubList");
  final DatabaseReference user = new FirebaseDatabase().reference().child("User").child("UserAccount");

  String _clubName = "";
  String _introduction = "";
  String _name = "";
  String _email = "";


  Future<String> readData() async{
    final ref = fb.reference();

    await user.reference().child(currentUser!.uid).child("name").once().then((DataSnapshot snapshot){
      _name = snapshot.value.toString();
      print(_name);
    });

    await user.reference().child(currentUser!.uid).child("email").once().then((DataSnapshot snapshot){
      _email = snapshot.value.toString();
      print(_email);
    });

    try {
      ref.child("Club").child(_clubName).set({
        "Introduction": _introduction,
        "President": FirebaseAuth.instance.currentUser!.uid
      });
      ref.child("Club").child(_clubName).child("ClubUserList").child(FirebaseAuth.instance.currentUser!.uid).set({
        "Name": _name,
        "Email": _email,
        "Grade": "회장",
      });

      ref.child("Club").child("ClubListName").child("ClubName").set(_clubName);
      user.child(currentUser!.uid).child("Club").child("ClubName").set(_clubName);

      insertListToast("동호회를 만들었습니다.");
      Navigator.pop(context);

    } catch (e) {
      print(e);
    }


    return "success";
  }


  void validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid clubName: $_clubName, introduction: $_introduction');
    } else {
      print(
          'Form is invalid clubName: $_clubName, introduction: $_introduction');
    }
  }

  @override
  Widget build(BuildContext context) {
    //final ref = fb.reference();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('MakeClub Page'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'ClubName'),
                  validator: (value) =>
                      value!.isEmpty ? 'ClubName can\'t be empty' : null,
                  onSaved: (value) => _clubName = value!,
                ),
                TextFormField(
                  //obscureText: true,
                  decoration: InputDecoration(labelText: 'Club introduction'),
                  validator: (value) => value!.isEmpty
                      ? 'Club introduction can\'t be empty'
                      : null,
                  onSaved: (value) => _introduction = value!,
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () async {
                      readData();
                      validateAndSave();
                    },
                    child: Text("MakeClub")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void insertListToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.greenAccent,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM);
}




