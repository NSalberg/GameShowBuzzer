import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BuzzerPage extends StatefulWidget {
  const BuzzerPage({Key? key, required this.roomCode}) : super(key: key);

  final String roomCode;

  @override
  State<BuzzerPage> createState() => _BuzzerPageState();
}

class _BuzzerPageState extends State<BuzzerPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String name = '';
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder<QuerySnapshot>(
            future: db
                .collection("room")
                .where("room code", isEqualTo: widget.roomCode)
                .get(),
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
                final docID = snapshot.data!.docs.first.id;
                final docRef = db.collection("room").doc(docID);
                docRef.snapshots().listen(
                  (event) {
                    print("current data: ${event.data()}");

                  },
                  onError: (error) => print("Listen failed: $error"),
                );
                children = <Widget>[
                  Text("Room code: ${widget.roomCode}"),
                  Text("Name: $name"),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Buzz In"),
                  )
                ];
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
            }));
  }
}
