import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:meetup/screens/allMeets.dart';
import 'package:meetup/screens/createEventScreen.dart';
import 'package:meetup/screens/createGroupScreen.dart';
import 'package:meetup/screens/homeScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants.dart';

Future<void > main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

//  var clientId = ClientId(ANDROID_CLIENT_KEY, "");
//  var scopes =  [cal.CalendarApi.calendarScope];
//  await clientViaUserConsent(clientId, scopes, userPrompt);
  runApp(MyApp());
}

//void userPrompt(String url) async{
//  if(await canLaunch(url)){
//    await launch(url);
//  }else{
//    print("CANNOT LAUNCH" + url);
//  }
//}

class MyApp extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return SafeArea(child: Center(child: Text("Error"),));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Events Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              accentColor: mainRedColor,
            ),
            home: HomeScreen(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return SafeArea(child: Center(child: CircularProgressIndicator(),));
      },
    );
  }
}