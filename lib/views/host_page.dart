import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_show_buzzer/widgets/rounded_button.dart';
import '../utils/app_colors.dart' as AppColors;
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
  bool _visible = false;


  @override
  void initState()  {
    super.initState();
    createRoom();
  }
  @override
  void dispose(){
    db.collection("room")
        .doc(docID)
        .set(<String,dynamic>{"open": false },SetOptions(merge: true))
        .then((value) => print("room: $roomCode closed"));
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
    }) .catchError((error) => print("Failed to create room"));
    db.collection("room").doc(docID).set(
        <String,dynamic>{
          "room code": roomCode,
          "open": true,
          "timestamp": FieldValue.serverTimestamp(),
        }
        );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          title: Text("Code: $roomCode", ),
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(20)),
              Text("Room Code",style: TextStyle(color: Colors.white, fontSize: 16),),
              Text(roomCode, style: TextStyle(color: Colors.white, fontSize: 75),),
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
               colour: AppColors.textField,
               title: "Join",
                  onPressed: () {
                    if (name != "") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              BuzzerPage(roomCode: roomCode, name: name,))
                      );
                    }else{
                      setState(() {
                        _visible = true;
                      });
                    }
                  }
             ),
              Opacity(
                opacity: _visible ? 1.0 : 0.0,
                child: const Text(
                  'Invalid name',
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
