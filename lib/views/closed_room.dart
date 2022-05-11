import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../utils/app_colors.dart' as AppColors;
import '../widgets/rounded_button.dart';

class ClosedRoom extends StatefulWidget {
  const ClosedRoom({Key? key}) : super(key: key);

  @override
  State<ClosedRoom> createState() => _ClosedRoomState();
}

class _ClosedRoomState extends State<ClosedRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          const Text(
            "Room no longer exists",
            style: TextStyle(color: Colors.white, fontSize: 45),
            textAlign: TextAlign.center,
          ),
          RoundedButton(colour: AppColors.textField, title: "Go to lobby", onPressed: (){
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }
}
