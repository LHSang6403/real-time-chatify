import 'package:flutter/material.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return buildUI(context, height, width);
  }

  Widget buildUI(BuildContext context, double height, double width) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "People",
          style: TextStyle(
              color: Colors.white,
              fontSize: width * 0.07,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          child: Center(
        child: Text(
          "People Page",
          style: TextStyle(
              color: Colors.black,
              fontSize: width * 0.07,
              fontWeight: FontWeight.bold),
        ),
      )),
    );
  }
}
