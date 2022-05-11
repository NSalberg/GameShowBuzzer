import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../utils/app_colors.dart' as AppColors;
import '../widgets/buzzer_button.dart';

class BuzzerPage extends StatefulWidget {
  const BuzzerPage({Key? key, required this.roomCode, required this.name}) : super(key: key);

  final String roomCode;
  final String name;

  @override
  State<BuzzerPage> createState() => _BuzzerPageState();
}

class _BuzzerPageState extends State<BuzzerPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String docID = "";
  late DocumentReference docRef;



  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    db.collection("room").doc(docID).update(<String, dynamic>{widget.name: FieldValue.delete(),});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Room code: ${widget.roomCode}"),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: db.collection("room")
                .where("room code", isEqualTo: widget.roomCode)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              List<Widget> children;
              if (snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Something went wrong'),
                  )
                ];
              }
              if (snapshot.hasData) {
                var data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                docID = snapshot.data!.docs.first.id;
                //if someone is buzzed in change the screen

                if (data["buzzes"] != null){
                  //find the earliest buzz
                  String buzzedInUser = "";
                  num earliestBuzz = 8640000000000000000;
                  data["buzzes"].forEach((key, value) {
                    if(value < earliestBuzz){
                      buzzedInUser = key;
                      earliestBuzz = value;
                    }
                  });
                  children = <Widget>[
                        Text("${buzzedInUser} buzzed in!", style: TextStyle(color: Colors.white, fontSize: 45),),
                  ];
                }else{
                  children = <Widget>[

                    BuzzerButton(
                      title: "Buzz in",
                      colour: AppColors.textField,
                      size: 300,
                      onPressed: () {
                        db.collection("room").doc(docID).set(<String,dynamic>{"buzzes": <String,dynamic>{widget.name: DateTime.now().microsecondsSinceEpoch}}, SetOptions(merge: true));
                        Future.delayed(Duration(seconds: 5), (){
                          db.collection("room").doc(docID).update(<String, dynamic>{"buzzes": FieldValue.delete(),});
                        });
                      },
                    )
                  ];
                }
              } else {
                children = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  )
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              );
            })
    );
  }
}
