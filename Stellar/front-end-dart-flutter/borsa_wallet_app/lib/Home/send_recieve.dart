import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SendReceive extends StatefulWidget {
  Future<int> id;
  String number;
  SendReceive(this.id, this.number);

  @override
  _SendReceiveState createState() => _SendReceiveState();
}

class _SendReceiveState extends State<SendReceive> {
  int id;
  Widget loading = Text("");

  TextEditingController amount = new TextEditingController();
  TextEditingController message = new TextEditingController();
  TextEditingController receiver = new TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.id.then((value) => id = value);
    amount.text = widget.number;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xff455A64),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: showList(),
    );
  }

  showList() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    controller: amount,
                    decoration: InputDecoration(
                      hintText: "Amount",
                      enabled: false,
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintStyle: TextStyle(color: Colors.grey[700]),
                      icon: Icon(Icons.monetization_on),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xff455A64), width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueGrey, width: 1.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    controller: message,
                    decoration: InputDecoration(
                      hintText: "Add message",
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintStyle: TextStyle(color: Colors.grey[700]),
                      icon: Icon(Icons.message),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xff455A64), width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueGrey, width: 1.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              textInputAction: TextInputAction.send,
              controller: receiver,
              onSubmitted: (val) {
                setState(() {
                  loading = CircularProgressIndicator();
                  if (val.isEmpty) {
                  } else if (isNumeric(val)) {
                    transferFundsToPhone(
                            id, val, message.text, double.parse(amount.text))
                        .catchError((err) {
                      loading = Text(err);
                    }).whenComplete(() {
                      setState(() {
                        loading = Text("Done");
                      });
                    });
                    ;
                  } else {
                    transferFundsToUsername(
                            id, val, message.text, double.parse(amount.text))
                        .catchError((err) {
                      loading = Text(err);
                    }).whenComplete(() {
                      setState(() {
                        loading = Text("Done");
                      });
                    });
                  }
                });
              },
              decoration: InputDecoration(
                hintText: "Add Receipent",
                filled: true,
                fillColor: Colors.grey[300],
                hintStyle: TextStyle(color: Colors.grey[700]),
                icon: Icon(Icons.search),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff455A64), width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 500,
              height: 1,
              child: Container(
                color: Colors.blueGrey,
              ),
            ),
            loading
          ],
        ),
      ),
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  Future<http.Response> transferFundsToUsername(
      int fromId, String toUsername, String message, double amount) {
    return http
        .post(
      Uri.parse('http://10.0.2.2:8080/user/sendtoemail'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "from": fromId.toString(),
        "toUsername": toUsername,
        "message": message,
        "amount": amount.toString()
      }),
    )
        .catchError((ex) {
      print(ex.toString());
    });
  }

  Future<http.Response> transferFundsToPhone(
      int fromId, String toUsername, String message, double amount) {
    return http
        .post(
      Uri.parse('http://10.0.2.2:8080/user/sendtophone'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "from": fromId.toString(),
        "toUsername": toUsername,
        "message": message,
        "amount": amount.toString()
      }),
    )
        .catchError((ex) {
      print(ex.toString());
    });
  }
}
