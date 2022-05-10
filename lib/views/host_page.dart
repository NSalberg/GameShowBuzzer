import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_show_buzzer/views/buzzer_page.dart';
class HostPage extends StatefulWidget {
  const HostPage({Key? key}) : super(key: key);

  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String docID = "";
  String roomCode = "";
  String name = "";


  @override
  void initState()  {
    super.initState();
    createRoom();
  }
  @override
  void dispose(){
    db.collection("room")
        .doc(docID)
        .delete()
        .then((value) => print("room: $roomCode deleted"));
    super.dispose();
  }
  Future<void> createRoom() async{
    await db.collection("room")
        .add(<String,dynamic>{"room code": "temp"})
        .then((doc){
      docID = doc.id;
      setState(() {
        roomCode = docID.substring(docID.length - 4).toUpperCase();
      });


      print("Room code $roomCode");
      print("DocumentSnapshot added with ID: ${doc.id}");
    }) .catchError((error) => print("Failed to add user: $error"));
    db.collection("room").doc(docID).set(<String,dynamic>{"room code": roomCode});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Room Code: $roomCode"),
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
                    //Todo: push buzzer screen
                    db.collection("room").doc(docID).set(<String,dynamic>{"player": name}, SetOptions(merge: true));
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
