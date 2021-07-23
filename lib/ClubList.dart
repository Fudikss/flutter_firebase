import 'package:firebase_database/firebase_database.dart';

class ClubList{
  String key = "";
  String clubName = "";

  ClubList(this.clubName, this.key);

  ClubList.fromSnapshot(DataSnapshot snapShot){
    key = snapShot.key!;
    clubName = snapShot.value["Club"];
  }

  toJson(){
    return{
      "clubName": clubName,
    };
  }
}