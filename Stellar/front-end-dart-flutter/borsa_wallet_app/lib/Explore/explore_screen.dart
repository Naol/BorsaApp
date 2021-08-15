import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  @override
  ExploreState createState() => ExploreState();
}

class ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    TextEditingController searchServices = new TextEditingController();
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                textInputAction: TextInputAction.send,
                controller: searchServices,
                decoration: InputDecoration(
                  hintText: "Search Services",
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintStyle: TextStyle(color: Colors.grey[700]),
                  icon: Icon(Icons.search),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xff455A64), width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              GridView.count(
                  // Create a grid with 2 columns. If you change the scrollDirection to
                  // horizontal, this produces 2 rows.
                  physics: ScrollPhysics(),
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  // Generate 100 widgets that display their index in the List.
                  children: [
                    Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage("assets/taxi.png"),
                            width: 80,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Ride Hailing",
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage("assets/fast-food.png"),
                            width: 80,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Restaurants",
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage("assets/gas-pump.png"),
                            width: 80,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Gas Stations",
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage("assets/delivery-man.png"),
                            width: 80,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Delivery",
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage("assets/plane-ticket.png"),
                            width: 80,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Buy Plane Tickets",
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
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
