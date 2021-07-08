import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:meetup/constants.dart';
import 'package:meetup/utils/firebaseHandler.dart';
import 'package:meetup/models/eventModel.dart';
import 'package:url_launcher/url_launcher.dart';

class AllMeetsScreen extends StatefulWidget {
  @override
  _AllMeetsScreenState createState() => _AllMeetsScreenState();
}

class _AllMeetsScreenState extends State<AllMeetsScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainRedColor,
        centerTitle: true,
        title: Text(
          "All Events",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Colors.white
            )
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: StreamBuilder<QuerySnapshot>(
            stream: events.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.length > 0) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> eventModel =
                              snapshot.data.docs[index].data();

                          EventModel event = EventModel.fromJson(eventModel);

                          DateTime startTime =
                              DateTime.fromMillisecondsSinceEpoch(
                                  event.startTimeSinceepoch);
                          DateTime endTime =
                              DateTime.fromMillisecondsSinceEpoch(
                                  event.endTimeSinceEpoch);

                          String startTimeString =
                              DateFormat.jm().format(startTime);
                          String endTimeString =
                              DateFormat.jm().format(endTime);
                          String dateString =
                              DateFormat.yMMMMd().format(startTime);

                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                                color: mainRedColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      event.title,
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Colors.white, fontSize: 24)),
                                    ),
                                    TextButton(
                                      onPressed: () async{
                                        await launch(event.link);
                                      },
                                      style: TextButton.styleFrom(
                                          backgroundColor: mainBeigeColor,
                                          padding: EdgeInsets.symmetric(vertical: 2.0 , horizontal: 5.0)
                                      ),
                                      child: Text(
                                        "Join Now",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: matteBlack,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold
                                            )
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  event.description,
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Location: ",
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)),
                                    ),
                                    Text(
                                      event.location,
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Divider(
                                    color: mainBeigeColor,
                                    thickness: 1,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      dateString,
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          startTimeString,
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16)),
                                        ),
                                        Text(
                                          " to ",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16)),
                                        ),
                                        Text(
                                          endTimeString,
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                  );
                } else {
                  return Container(
                    child: Center(
                      child: Text("No Events"),
                    ),
                  );
                }
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Text('Something went wrong');
            },
          ),
        ),
      ),
    );
  }
}
