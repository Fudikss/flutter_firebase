import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/CLubList.dart';


class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  FirebaseAuth auth = FirebaseAuth.instance;

  var currentUser = FirebaseAuth.instance.currentUser;

  final dbRef = FirebaseDatabase.instance.reference().child("User").child("UserAccount").child(FirebaseAuth.instance.currentUser!.uid).child("Club").child("ClubName");
  final _dbref = FirebaseDatabase.instance.reference();

  List lists = [];
  List data = [];


  Future<String> readData() async{

    await dbRef.once().then((DataSnapshot snapshot){


      lists.add(snapshot.value.toString());

      print("Data : ${snapshot.value.toString()}");
    });



    //data = await jsonDecode(jsonEncode(lists));
    data = await json.decode(json.encode(lists));
    print(data);

    this.setState(() {
      // ignore: unnecessary_statements
      this.lists;
    });
    return "success";
  }

  void deleteData() async{
    await dbRef.remove();
    this.setState(() {
      data.clear();

      //readData();
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    this.readData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Join Clubs"),
        ),
        body: ListView.builder(
          itemCount:  data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index){
            return Card(
              child: Row(
                children: [
                  Text(data[index]),
                  ButtonBar(
                    alignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: (){
                          print(data[index]);
                          //test = lists[index]["ClubList"];
                          //print(test);
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text('탈퇴 알림'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: [
                                        Text('동아리를 탈퇴하시겠습니까?'),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: (){
                                          deleteData();
                                          data.remove(data[index]);
                                          deleteListToast("탈퇴하였습니다");
                                        },
                                        child: Text('OK')),

                                    TextButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel')),
                                  ],
                                );
                              }
                          );
                        },
                        child: Text('Delete Club'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        )
    );
  }
}

void deleteListToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.greenAccent,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM);
}

