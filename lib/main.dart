import 'package:flutter/material.dart';
import 'package:game_show_buzzer/idProvider.dart';
import 'package:game_show_buzzer/widgets/rounded_button.dart';
import 'views/room_page.dart';
import 'views/host_page.dart';
import 'views/buzzer_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'utils/app_colors.dart' as AppColors;
import "package:provider/provider.dart";
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ID(),
      child: MaterialApp(
        initialRoute: "lobby_screen",
        routes: {
          'lobby_screen': (context) =>
              const MyHomePage(title: "Game Show Buzzer"),
          'room_screen': (context) => const RoomPage(),
          'host_screen': (context) => const HostPage(),
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Game Show Buzzer'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundedButton(
                  title: "Host Lobby",
                  colour: AppColors.textField,
                    onPressed: () {
                      Navigator.pushNamed(context, 'host_screen');
                    },
                ),
                const Padding(padding: EdgeInsets.all(16.0)),
                RoundedButton(
                    title: "Join Lobby",
                    colour: AppColors.textField,
                    onPressed: () {
                      Navigator.pushNamed(context, 'room_screen');
                    },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
