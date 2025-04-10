import 'package:flutter/material.dart';
class DividerOr extends StatelessWidget {

  DividerOr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
  children: [
    Expanded(
      child: Divider(
        color: Colors.grey, // Color of the divider
        thickness: 1, // Thickness of the divider
      ),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0), // Space around "or"
      child: Text(
        "OR",
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
    ),
    Expanded(
      child: Divider(
        color: Colors.grey,
        thickness: 1,
      ),
    ),
  ],
);
  }
}
