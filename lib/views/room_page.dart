import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../utils/app_colors.dart' as AppColors;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/rounded_button.dart';
import 'buzzer_page.dart';
class RoomPage extends StatefulWidget {
  const RoomPage({Key? key}) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  String roomCode = "";
  String name = "";
  FirebaseFirestore db = FirebaseFirestore.instance;
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Join Lobby"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.all(20)),
              Text("Room Code",style: TextStyle(color: Colors.white, fontSize: 16),),
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.textField,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      roomCode = value;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 20.0),
                      labelText: 'Enter your name',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
              ),
              Text("Name",style: TextStyle(color: Colors.white, fontSize: 16),),
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.textField,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      name = value;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 20.0),
                      labelText: 'Enter your name',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
              ),
              RoundedButton(
                title: "Join",
                colour: AppColors.textField,
                  onPressed: () async {
                    var snap = await db.collection("room").where("room code", isEqualTo: roomCode).get();
                    if(snap.docs.length == 1){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BuzzerPage(roomCode: roomCode, name: name,))
                      );
                    } else {
                      setState(() {
                        _visible = true;
                      });
                    }
                  },
              ),
              Opacity(
                opacity: _visible ? 1.0 : 0.0,
                child: const Text(
                  'Invalid room code',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.red,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
