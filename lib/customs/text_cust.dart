import 'package:flutter/material.dart';

class textcust extends StatelessWidget {
  textcust(
      {super.key, required this.title, this.bold, this.colortitle, this.size});
  String title;
  FontWeight? bold;
  Color? colortitle;
  double? size;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontWeight: bold, color: colortitle, fontSize: size),
    );
  }
}
