import 'package:flutter/material.dart';
import '../utils/app_colors.dart' as AppColors;

class RoundedButton extends StatelessWidget {
  RoundedButton(
      {required this.colour, required this.title, required this.onPressed});
  final Color colour;
  final String title;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          //Go to login screen.
          minWidth: 180.0,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}