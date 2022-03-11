import 'package:flutter/material.dart';

class GardenPage extends StatefulWidget {
  GardenPage({Key? key}) : super(key: key);

  @override
  _GardenPageState createState() => _GardenPageState();
}

class _GardenPageState extends State<GardenPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("garden"),
    );
  }
}
