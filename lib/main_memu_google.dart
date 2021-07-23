import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'makeClub.dart';
import 'MyProfile.dart';
import 'SearchClub.dart';

class MainMenuGoogle extends StatefulWidget {
  const MainMenuGoogle({Key? key}) : super(key: key);

  @override
  _MainMenuGoogleState createState() => _MainMenuGoogleState();
}

class _MainMenuGoogleState extends State<MainMenuGoogle> {
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference mDatabase = FirebaseDatabase.instance.reference();

  var currentUser = FirebaseAuth.instance.currentUser;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  final DatabaseReference name = FirebaseDatabase.instance.reference().child("User").child("UserAccount").child(FirebaseAuth.instance.currentUser!.uid).child("name");
  final DatabaseReference email = FirebaseDatabase.instance.reference().child("User").child("UserAccount").child(FirebaseAuth.instance.currentUser!.uid).child("email");

  Future<void> signOut() async{
    try{
      await googleSignIn.disconnect();
      await googleSignIn.signOut();
      print("Success");

    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appbar icon menu'),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              print('Search button is clikcked');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              /*currentAccountPicture: CircleAvatar(
                //backgroundImage: AssetImage('accets/chopa.PNG'),
                backgroundColor: Colors.white,
              ),
              otherAccountsPictures: [
                CircleAvatar(
                  backgroundImage: AssetImage('accets/lupie.PNG'),
                  backgroundColor: Colors.white,
                ),
                // CircleAvatar(
                //   backgroundImage: AssetImage('accets/lupie.PNG'),
                //   backgroundColor: Colors.white,
                // )
              ],*/
              accountName: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(!snapshot.hasData){
                    return Text("오류");
                  }else{
                    return Text(snapshot.data.displayName);
                  }
                },
              ),
              accountEmail: StreamBuilder(
                stream: email.onValue,
                builder: (context, AsyncSnapshot<Event> snap){
                  if(!snap.hasData) return Text("오류");
                  return Text(snap.data!.snapshot.value.toString());
                },
              ),
              onDetailsPressed: () {
                print('arrow is clicked');
              },
              decoration: BoxDecoration(
                  color: Colors.red[200],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0))),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.grey[850],
              ),
              title: Text('프로필'),
              onTap: () {
                print('My Page is clicked');
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context){
                      return MyProfile();
                    }
                ));
              },
              trailing: Icon(Icons.add),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.grey[850],
              ),
              title: Text('가입한 동호회'),
              onTap: ()  {
                showToast("동호회");
              },
              trailing: Icon(Icons.add),
            ),
            ListTile(
              leading: Icon(
                Icons.question_answer,
                color: Colors.grey[850],
              ),
              title: Text('채팅리스트'),
              onTap: () {
              },
              trailing: Icon(Icons.add),
            ),
            ListTile(
              leading: Icon(
                Icons.question_answer,
                color: Colors.grey[850],
              ),
              title: Text('동호회 검색'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context){
                      return SearchClub();
                    }
                ));
              },
              trailing: Icon(Icons.add),
            ),
            ListTile(
              leading: Icon(
                Icons.question_answer,
                color: Colors.grey[850],
              ),
              title: Text('동호회 창설'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context){
                      return MakeClub();
                    }
                ));
              },
              trailing: Icon(Icons.add),
            ),
            SizedBox(
              height: 100,
            ),
            ElevatedButton(
                onPressed: (){
                  signOut();
                  signOutToast("로그아웃 하였습니다.");
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()), (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[200],
                ),
                child: Text("로그아웃"))
          ],
        ),
      ),
    );
  }
}

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.greenAccent,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM);
}

void signOutToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.greenAccent,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM);
}
