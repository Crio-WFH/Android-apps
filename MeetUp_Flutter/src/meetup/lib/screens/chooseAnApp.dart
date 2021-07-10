import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:meetup/constants.dart';

class ChooseAppScreen extends StatefulWidget {
  @override
  _ChooseAppScreenState createState() => _ChooseAppScreenState();
}

class _ChooseAppScreenState extends State<ChooseAppScreen> {
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainRedColor,
        centerTitle: true,
        title: Text(
          "Choose An App",
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: Colors.white
              )
          ),
        ),
      ),

      body: SafeArea(
        child: Container(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                "images/chooseApp.svg",
                height: 300,
              ),
              MeetAppButton(
                appName: "Zoom Meetings",
                background: Color(0xFF2C88F7),
                appLogo: "images/zoomLogo.png",
                packageName: "us.zoom.videomeetings",
              ),
              MeetAppButton(
                appName: "Microsoft Teams",
                background: Color(0xFF5558AF),
                appLogo: "images/microsoftTeamsLogo.png",
                packageName: "com.microsoft.teams",
              ),
              MeetAppButton(
                appName: "Skype Call",
                background: Color(0xFF0099DB),
                appLogo: "images/skypeLogo.png",
                packageName: "com.skype.raider",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MeetAppButton extends StatelessWidget {

  final String appName;
  final String appLogo;
  final Color background;
  final String packageName;

  MeetAppButton({
    Key key,
    this.appLogo,
    this.appName,
    this.background,
    this.packageName
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextButton(
        onPressed: (){
          LaunchApp.openApp(
            androidPackageName: packageName,
          );
        },
        style: TextButton.styleFrom(
          backgroundColor: background,
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appName,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 40,
                      width: 2,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Image.asset(
                    appLogo,
                    height: 40,
                  )
                ],
              ),
            ],
          )
        ),
      ),
    );
  }
}
