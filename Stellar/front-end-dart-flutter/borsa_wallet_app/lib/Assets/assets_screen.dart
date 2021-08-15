import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Assets extends StatefulWidget {
  @override
  AssetsState createState() => AssetsState();
}

class AssetsState extends State<Assets> {
  String balance = "Loading";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

//    fetchBalance();
    return SafeArea(
      child: Column(
        children: [
          ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              Card(
                  child: Container(
                width: 300,
                child: ListTile(
                  title: Text("ETBT"),
                  subtitle: Text("Ethiopian Birr Token"),
                  leading: Icon(Icons.filter_list),
                  trailing: FutureBuilder(
                      future: fetchBalance(),
                      builder: (BuildContext context,
                          AsyncSnapshot<http.Response> snapshot) {
                        if (snapshot.hasError) {
                          return Text("Internet Error");
                        } else if (snapshot.hasData) {
                          if (snapshot.data.statusCode != 200) {
                            return Text("Server Error");
                          } else {
                            return RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(
                                      text: snapshot.data.body.toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: '   ETB',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ]),
                            );
                          }
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Future<http.Response> fetchBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    print(prefs.getInt("id").toString() + " ffffffsdfdsf");
    return http
        .post(
      Uri.parse('http://10.0.2.2:8080/user/getbalancebyid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"from": prefs.getInt("id").toString()}),
    )
        .catchError((ex) {
      print(ex.toString());
    });
  }
}

class MyColor extends MaterialStateColor {
  const MyColor() : super(_defaultColor);

  static const int _defaultColor = 0xcafefeed;
  static const int _pressedColor = 0xff455A64;

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return const Color(_pressedColor);
    }
    return const Color(_defaultColor);
  }
}
