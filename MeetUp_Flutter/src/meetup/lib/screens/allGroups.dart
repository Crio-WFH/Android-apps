import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:meetup/constants.dart';
import 'package:meetup/main.dart';
import 'package:meetup/models/groupModel.dart';
import 'package:meetup/screens/createEventScreen.dart';
import 'package:meetup/utils/firebaseHandler.dart';
import 'package:meetup/models/eventModel.dart';
import 'package:url_launcher/url_launcher.dart';

class AllGroupsScreen extends StatefulWidget {
  @override
  _AllGroupsScreenState createState() => _AllGroupsScreenState();
}

class _AllGroupsScreenState extends State<AllGroupsScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionReference groups =
        FirebaseFirestore.instance.collection('groups');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainRedColor,
        centerTitle: true,
        title: Text(
          "All Groups",
          style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white)),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: StreamBuilder<QuerySnapshot>(
            stream: groups.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.length > 0) {
                  return Padding(
                    padding: EdgeInsets.all(12.0),
                    child: ListView.separated(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> groupJson =
                            snapshot.data.docs[index].data();

                        Group group = Group.fromJson(groupJson);

                        return ListTile(
                            title: Text(
                              group.groupName,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: mainRedColor, fontSize: 20)),
                            ),
                            subtitle: ListView.builder(
                              itemCount: group.emailsList.length,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Text(
                                  group.emailsList[index],
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: matteBlack, fontSize: 16)),
                                );
                              },
                            ));
                      },
                      separatorBuilder: (context, index) {
                        return CustomDivider();
                      },
                    ),
                  );
                } else {
                  return Container(
                    child: Center(
                      child: Text("No Groups"),
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
