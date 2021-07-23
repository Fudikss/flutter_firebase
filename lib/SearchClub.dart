import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SearchClub extends StatefulWidget {
  const SearchClub({Key? key}) : super(key: key);


  @override
  _SearchClubState createState() => _SearchClubState();
}

class _SearchClubState extends State<SearchClub> {
  final formKey = new GlobalKey<FormState>();

  String _searchClubName = "";

  void validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid ClubName: $_searchClubName');
    } else {
      print('Form is invalid ClubName: $_searchClubName');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title:  Text('Search Club Page'),
      ),
      body:  SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child:  Form(
            key: formKey,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration:  InputDecoration(labelText: '검색하려는 동호회 이름을 입력해주세요',
                      border: OutlineInputBorder()),
                  validator: (value) =>
                  value!.isEmpty ? 'ClubName can\'t be empty' : null,
                  onSaved: (value) => _searchClubName = value!,
                ),
                SizedBox(height: 5,),
                ElevatedButton(
                    onPressed: () async {
                      validateAndSave();
                    },
                    child: Text("Login")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
