import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../controller_page.dart';
import 'file:///D:/Projects/AndroidStudio/Flutter/BorsaApp/borsa_wallet_app/lib/LoginSignup/signup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../LoginSignup/Widget/bezierContainer.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, TextEditingController tec,
      {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              controller: tec,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xffBBDEFB), Color(0xff455A64)])),
      child: Text(
        'Login',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xff455A64),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(text: 'd', children: [
        TextSpan(
          text: 'Borsa',
          style: TextStyle(color: Color(0xff455A64), fontSize: 30),
        ),
        TextSpan(
          text: 'Wallet',
          style: TextStyle(color: Color(0xffBBDEFB), fontSize: 30),
        ),
      ]),
    );
  }

  TextEditingController username = new TextEditingController(),
      passwd = new TextEditingController();

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Username", username),
        _entryField("Password", passwd, isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _title(),
                  SizedBox(height: 50),
                  _emailPasswordWidget(),
                  SizedBox(height: 20),
                  GestureDetector(
                      child: _submitButton(),
                      onTap: () {
                        setState(() {
                          checkCredentials(username.text, passwd.text)
                              .then((value) {
                            if (value.statusCode != 200) {
                            } else if (value.body == "0") {
                            } else {
                              login(jsonDecode(value.body)).whenComplete(() =>
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ControllerPage())));
                            }
                          });
                        });
                      }),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: Text('Forgot Password ?',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  _divider(),
                  SizedBox(height: height * .055),
                  _createAccountLabel(),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    ));
  }

  Future<http.Response> checkCredentials(String uname, String pwd) {
    return http
        .post(
      Uri.parse('http://10.0.2.2:8080/user/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": uname,
        "pass": pwd,
      }),
    )
        .catchError((ex) {
      print(ex.toString());
    });
  }

  Future<void> login(jsonDecode) async {
    print(jsonDecode.toString());

    int id = jsonDecode['id'] as int;
    String username = jsonDecode['username'] as String;
    String pno = jsonDecode['phoneNumber'] as String;
    String name = (jsonDecode['firstName'] as String) +
        " " +
        (jsonDecode['fatherName'] as String) +
        " " +
        (jsonDecode['gFatherName'] as String);
    String dob = jsonDecode['DOB'] as String;
    String status = jsonDecode['status'] as String;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("id", id);
    prefs.setString("username", username);
    prefs.setString("pno", pno);
    prefs.setString("name", name);
    prefs.setString("dob", dob);
    prefs.setString("status", status);

    http
        .get(Uri.parse('http://10.0.2.2:8080/user/getpkey/' + username))
        .then((value) {
      print(value.body);
      prefs.setString("pkey", value.body.trim().toString());
    }).catchError((ex) {
      print(ex.toString());
    });
  }
}
