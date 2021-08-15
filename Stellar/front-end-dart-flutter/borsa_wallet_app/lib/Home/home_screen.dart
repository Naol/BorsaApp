import 'package:borsawalletapp/Home/send_recieve.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<Home> {
  String number = '0';
  bool pointed = false;
  int decimal = 2;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    bool pressAttention = true;

    return SafeArea(
        child: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 30),
                    child: Center(
                        child: Text(
                      number,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.blueGrey),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(
            child: gridView(),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff455A64),
                      onPrimary: Color(0xffd3d3d3),
                    ),
                    onPressed: () => setState(() {
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) =>
//                                  SendReceive(getId(), number)));
                      return pressAttention = !pressAttention;
                    }),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Text(
                        "Recieve",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff455A64),
                      onPrimary: Color(0xffd3d3d3),
                    ),
                    onPressed: () => setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SendReceive(getId(), number)));
                      return pressAttention = !pressAttention;
                    }),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Text(
                        "Send",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
          ),
        ),
      ],
    ));
  }

  Widget gridView() {
    textButtonGen(String i) {
      bool pressAttention = true;
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: Colors.grey[200]),
        margin: EdgeInsets.all(10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color(0xffd3d3d3),
            onPrimary: Color(0xff455A64),
          ),
          onPressed: () => setState(() {
            if (i == '.') {
              if (!pointed) {
                number += '.';
                pointed = true;
              }
            } else if (number == '0') {
              number = i;
            } else {
              if (!pointed) {
                number += i;
              } else if (pointed && decimal > 0) {
                number += i;
                decimal--;
              }
            }
            return pressAttention = !pressAttention;
          }),
          child: Text(
            i,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 3,
      children: [
        textButtonGen("1"),
        textButtonGen("2"),
        textButtonGen("3"),
        textButtonGen("4"),
        textButtonGen("5"),
        textButtonGen("6"),
        textButtonGen("7"),
        textButtonGen("8"),
        textButtonGen("9"),
        textButtonGen("."),
        textButtonGen("0"),
        GestureDetector(
            onTap: () {
              setState(() {
                number = '0';
                pointed = false;
                decimal = 2;
              });
            },
            child: Icon(Icons.backspace)),
      ],
    );
  }

  Future<int> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("id");
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
