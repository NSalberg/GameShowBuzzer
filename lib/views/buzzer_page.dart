import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'closed_room.dart';
import '../utils/app_colors.dart' as AppColors;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:game_show_buzzer/ad_helper.dart';
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

  late BannerAd _ad;
  bool _isAdLoaded = false;

  @override
  void initState() {
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );
    _ad.load();
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
        body: stream()
    );
  }

  Widget stream() {
    return StreamBuilder<QuerySnapshot>(
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

            if(data["open"] == false){
              myCallback(() {
                Navigator.pop(context, true);
                Navigator.push(
                  context,
                    MaterialPageRoute(builder: (context) =>
                    const ClosedRoom())
                );
              });
            }
            //if someone is buzzed in change the screen
            if (data["buzzes"] != null ){
              //find the earliest buzz
              String buzzedInUser = widget.name;
              num earliestBuzz = 8640000000000000000;
              data["buzzes"].forEach((key, value) {
                if (value != null) {
                  Timestamp timeStamp = value;
                  if (timeStamp.microsecondsSinceEpoch < earliestBuzz) {
                    buzzedInUser = key;
                    earliestBuzz = timeStamp.microsecondsSinceEpoch;
                  }
                }
              });
              children = <Widget>[
                Text(
                  buzzedInUser,
                  style: const TextStyle(color: Colors.white, fontSize: 55),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "buzzed in!",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ];
            }else{
              children = <Widget>[
                BuzzerButton(
                  title: "Buzz",
                  colour: AppColors.lightAccent,
                  size: 300,
                  onPressed: () async {
                    await db.collection("room").doc(docID).set(<String,dynamic>{"buzzes": <String,dynamic>{widget.name: FieldValue.serverTimestamp(), }}, SetOptions(merge: true));
                    Future.delayed(Duration(seconds: 10), (){
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
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),
                ),
                if(_isAdLoaded)
                  Container(
                    child: AdWidget(ad: _ad),
                    height: _ad.size.height.toDouble(),
                    width: _ad.size.width.toDouble(),
                    alignment: Alignment.center,
                  ),
              ],
            ),
          );
        });
  }
  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  void myCallback(Function callback) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      callback();
    });
  }
}
