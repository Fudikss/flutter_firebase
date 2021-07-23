import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';


import 'makeAccount.dart';
import 'main_memu.dart';
import 'main_memu_google.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  bool success = false;
  String _email = "";
  String _password = "";

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    showToast("Success Login");
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return MainMenuGoogle();
    }));

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid Email: $_email, password: $_password');
    } else {
      print('Form is invalid Email: $_email, password: $_password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login Page'),
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
                  decoration: InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
                  validator: (value) =>
                      value!.isEmpty ? 'Email can\'t be empty' : null,
                  onSaved: (value) => _email = value!,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Password', border: OutlineInputBorder()),
                  validator: (value) =>
                      value!.isEmpty ? 'Password can\'t be empty' : null,
                  onSaved: (value) => _password = value!,
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () async {
                      validateAndSave();
                      try {
                        await Firebase.initializeApp();
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                                email: _email, password: _password);

                        success = true;
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-fount') {
                          wrongShowToast("해당 이메일에 대한 사용자를 찾을 수 없습니다.");
                          print("user-not-fount");
                          success = false;
                        } else if (e.code == 'wrong-password') {
                          wrongShowToast("사용자 비밀번호가 틀렸습니다.");
                          success = false;
                        }
                      }
                      if (success) {
                        showToast("Success Login");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return mainmenu();
                        }));
                      }
                    },
                    child: Text("Login")),
                ElevatedButton(
                    onPressed: () {
                      signInWithGoogle();
                    },
                    child: Text("Google Sign")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return makeAccount();
                      }));
                    },
                    child: Text("Sign up"),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Colors.redAccent
                ),),
                ElevatedButton(onPressed: () {}, child: Text("Find account")),
              ],
            ),
          ),
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

void wrongShowToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.redAccent,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM);
}
