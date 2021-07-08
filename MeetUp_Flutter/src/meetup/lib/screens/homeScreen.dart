import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetup/constants.dart';
import 'package:meetup/screens/allGroups.dart';
import 'package:meetup/screens/allMeets.dart';
import 'package:meetup/screens/createEventScreen.dart';
import 'package:meetup/screens/createGroupScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "MeetUp",
              style: GoogleFonts.poppins(
                textStyle:TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold
                )
              ),
            ),
            Container(
              height: height*0.3,
              child: SvgPicture.asset(
                "images/homePage.svg"
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: Column(
                children: [
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CreateScreen()));
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: mainRedColor
                    ),
                    child: Center(
                      child: Text(
                        "Create A New Event",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                          )
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AllMeetsScreen()));
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: mainRedColor
                    ),
                    child: Center(
                      child: Text(
                        "View All Events",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                            )
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGroup()));
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: mainRedColor
                    ),
                    child: Center(
                      child: Text(
                        "Create A New Group",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                            )
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AllGroupsScreen()));
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: mainRedColor
                    ),
                    child: Center(
                      child: Text(
                        "View All Groups",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                            )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}
