import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'buzzer_page.dart';



// Create a new user with a first and last name
final user = <String, dynamic>{
  "first": "Ada",
  "last": "Lovelace",
  "born": 1815
};


class RoomPage extends StatefulWidget {
  const RoomPage({Key? key}) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  String roomCode = "";
  String name = "";
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Room Code"),
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    onChanged: (value) {
                      roomCode = value;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 20.0),
                      labelText: 'Enter room code',
                      labelStyle: TextStyle(color: Colors.indigo, fontSize: 16),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.indigo, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
              ),
              Text("Name"),
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    onChanged: (value) {
                      name = value;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 20.0),
                      labelText: 'Enter your name',
                      labelStyle: TextStyle(color: Colors.indigo, fontSize: 16),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.indigo, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    db.collection("room")
                        .add(user)
                        .then((value){print("user added");})
                        .catchError((error) => print("Failed to add user: $error"));
                    //Todo: push buzzer screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BuzzerPage(roomCode: roomCode))
                    );

                    //Todo: check for server
                  },
                  child: Text("JOIN"))
            ],
          ),
        )
    );
  }
}
