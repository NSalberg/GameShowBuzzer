import 'package:flutter/material.dart';

class BuzzerButton extends StatelessWidget {
  BuzzerButton(
      {required this.colour, required this.title, required this.onPressed, required this.size});
  final Color colour;
  final String title;
  final Function() onPressed;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(size/4),
        child: MaterialButton(
          onPressed: onPressed,
          //Go to login screen.
          minWidth: size,
          height: size,
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
      ),
    );
  }
}