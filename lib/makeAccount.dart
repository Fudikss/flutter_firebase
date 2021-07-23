import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';

class makeAccount extends StatefulWidget {
  const makeAccount({Key? key}) : super(key: key);

  @override
  _makeAccountState createState() => _makeAccountState();
}

class _makeAccountState extends State<makeAccount> {
  bool success = false;
  final formKey = new GlobalKey<FormState>();
  final DatabaseReference fb = new FirebaseDatabase().reference().child("User");

  var currentUser = FirebaseAuth.instance.currentUser;

  String _email = "";
  String _password = "";
  String _name = "";
  String _phoneNum = "";
  String _birth = "";


  void validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid Email: $_email, password: $_password, name: $_name, phoneNum: $_phoneNum birth: $_birth');
    } else {
      print('Form is invalid Email: $_email, password: $_password, name: $_name, phoneNum: $_phoneNum birth: $_birth');
    }
  }

  @override
  Widget build(BuildContext context) {

    final ref = fb.reference();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Sign Up Page'),
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
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                  value!.isEmpty ? 'Email can\'t be empty' : null,
                  onSaved: (value) => _email = value!,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password(6자리 이상 입력)'),
                  validator: (value) =>
                  value!.isEmpty ? 'Password can\'t be empty' : null,
                  onSaved: (value) => _password = value!,
                ),
                TextFormField(
                  obscureText: false,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                  value!.isEmpty ? 'Name can\'t be empty' : null,
                  onSaved: (value) => _name = value!,
                ),
                TextFormField(
                  obscureText: false,
                  decoration: InputDecoration(labelText: 'PhoneNumber'),
                  validator: (value) =>
                  value!.isEmpty ? 'PhoneNumber can\'t be empty' : null,
                  onSaved: (value) => _phoneNum = value!,
                ),
                TextFormField(
                  obscureText: false,
                  decoration: InputDecoration(labelText: 'Birth'),
                  validator: (value) =>
                  value!.isEmpty ? 'Birth can\'t be empty' : null,
                  onSaved: (value) => _birth = value!,
                ),
                SizedBox(height: 30,),
                ElevatedButton(
                    onPressed: () async {
                      validateAndSave();
                      try {
                        //await Firebase.initializeApp();
                        UserCredential userCredential = await FirebaseAuth
                            .instance.createUserWithEmailAndPassword(
                            email: _email,
                            password: _password
                        );
                        success = true;
                      } on FirebaseAuthException catch(e) {
                        if (e.code == 'week-password') {
                          wrongShowToast('The password provided is too week.');
                          success = false;
                        } else if (e.code == 'email-already-in-use') {
                          wrongShowToast('해당 이메일은 등록되어 있습니다.');
                          success = false;
                        }
                      }
                      if(success) {
                        try {
                          ref.child("UserAccount").child(FirebaseAuth.instance.currentUser!.uid).set({"email": _email, "password": _password, "name": _name, "phoneNum": _phoneNum, "birth": _birth,
                          });
                          showToast("회원가입 완료");
                          Navigator.pop(context);
                        }catch (e){
                          print(e);
                        }
                      }
                    },

                    child: Text("Sign up")),
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