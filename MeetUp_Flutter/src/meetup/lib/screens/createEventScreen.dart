import 'package:flutter/material.dart';
import 'package:meetup/constants.dart';
import 'package:meetup/models/eventModel.dart';
import 'package:meetup/models/groupModel.dart';
import 'package:meetup/utils/calendarFunctions.dart';
import 'package:meetup/utils/firebaseHandler.dart';
import 'package:meetup/widgets/customTextField.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final emailFormKey = GlobalKey<FormState>();
  final eventDetailsFormKey = GlobalKey<FormState>();

  final titleController = new TextEditingController();
  final descriptionController = new TextEditingController();
  final locationController = new TextEditingController();
  final emailController = new TextEditingController();
  final List<calendar.EventAttendee> attendeesList = [];

  DateTime date = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();

  bool notifyAttendees = false;
  bool isConference = false;

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

  _selectTime(BuildContext context , bool isStartTime) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: isStartTime? startTime : endTime,
    );
    if(isStartTime){
      if (picked != null && picked != startTime) {
        setState(() {
          startTime = picked;
        });
      }
    } else {
      if(picked != null && picked != endTime){
        setState(() {
          endTime = picked;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    CollectionReference groups = FirebaseFirestore.instance.collection('groups');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainRedColor,
        centerTitle: true,
        title: Text(
          "Create An Event",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Colors.white,
            )
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left:20.0 , right: 20.0 , bottom: 20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "Enter Details",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: matteBlack,
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Form(
                  key: eventDetailsFormKey,
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      CustomTextField(
                        hint: "Title",
                        myController: titleController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          myController: descriptionController,
                          hint: "Description"
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          myController: locationController,
                          hint: "Location"
                      ),
                      CustomDivider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              DateFormat.yMMMd().format(date),
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: matteBlack,
                                  fontSize: 20,
                                )
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: (){
                                _selectDate(context);
                              },
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                            ),
                              child: Text(
                                "Change Date",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: mainRedColor,
                                      fontSize: 20,
                                    )
                                ),
                              ),
                          ),
                        ],
                      ),
                      CustomDivider(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              MaterialLocalizations.of(context).formatTimeOfDay(startTime),
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: matteBlack,
                                    fontSize: 20,
                                  )
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: (){
                              _selectTime(context, true);
                            },
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                            ),
                            child: Text(
                              "Change",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: mainRedColor,
                                    fontSize: 20,
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, bottom: 0.0),
                        child: Text(
                          "to",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              MaterialLocalizations.of(context).formatTimeOfDay(endTime),
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: matteBlack,
                                    fontSize: 20,
                                  )
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: (){
                              _selectTime(context, false);
                            },
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                            ),
                            child: Text(
                              "Change",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: mainRedColor,
                                    fontSize: 20,
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                      CustomDivider(),
                      Text(
                        "Add Attendees",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: matteBlack,
                              fontSize: 20,
                            )
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Form(
                        key: emailFormKey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 300,
                              child: TextFormField(
                                controller: emailController,
                                cursorColor: matteBlack,
                                validator: (value){
                                  Pattern pattern =
                                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                      r"{0,253}[a-zA-Z0-9])?)*$";
                                  RegExp regex = new RegExp(pattern);
                                  if (!regex.hasMatch(value) || value == null)
                                    return 'Enter a valid email address';
                                  else
                                    return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  focusColor: mainRedColor,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: mainRedColor, width: 2)
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: mainRedColor, width: 1)
                                  ),
                                ),
                              )
                            ),
                            GestureDetector(
                              onTap: (){
                                if(emailFormKey.currentState.validate()){
                                  setState(() {
                                    calendar.EventAttendee newAttendee = new calendar.EventAttendee();
                                    newAttendee.email = emailController.text;
                                    attendeesList.add(newAttendee);
                                    emailController.clear();
                                  });
                                }
                              },
                              child: Icon(
                                Icons.add_circle,
                                size: 40,
                                color: mainRedColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Or Select One of Your groups:",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: matteBlack,
                              fontSize: 20,
                            )
                        ),
                      ),
                      StreamBuilder(
                        stream: groups.snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if(snapshot.hasData){
                            if(snapshot.data.docs.length > 0){
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context , index){
                                    Map<String, dynamic> groupJson = snapshot.data.docs[index].data();
                                    Group group = Group.fromJson(groupJson);
                                    return InkWell(
                                      onTap: (){
                                        setState(() {
                                          group.emailsList.forEach((element) {
                                            calendar.EventAttendee newAttendee = new calendar.EventAttendee();
                                            newAttendee.email = element;
                                            attendeesList.add(newAttendee);
                                          });
                                        });
                                      },
                                      child: ListTile(
                                        title: Text(
                                          group.groupName,
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              fontSize: 18,
                                              color: mainRedColor
                                            )
                                          ),
                                        ),
                                        trailing: Icon(
                                          Icons.add_circle,
                                          size: 40,
                                          color: mainRedColor,
                                        ),
                                      ),
                                    );
                                  }
                              );
                            }
                            return Container();
                          }
                          return Container();
                        }
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Attendees:",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: matteBlack,
                              fontSize: 20,
                            )
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: attendeesList.length,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context,index){
                              return Text(
                                attendeesList[index].email,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: matteBlack
                                    )
                                ),
                              );
                            }
                        ),
                      ),
                      CustomDivider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Generate Google Meet:",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: matteBlack,
                                    fontSize: 18,
                                  )
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Transform.scale(
                              scale: 1.3,
                              child: Switch(
                                  value: isConference,
                                  onChanged: (value){
                                    setState(() {
                                      isConference = value;
                                    });
                                  }
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Notify Attendees:",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: matteBlack,
                                    fontSize: 18,
                                  )
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Transform.scale(
                              scale: 1.3,
                              child: Switch(
                                  value: notifyAttendees,
                                  onChanged: (value){
                                    setState(() {
                                      notifyAttendees = value;
                                    });
                                  }
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: width-40,
                        child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.only(top: 10.0 , bottom: 10.0),
                              backgroundColor: mainRedColor,
                            ),
                            onPressed: () async{
                              if(eventDetailsFormKey.currentState.validate()){

                                DateTime startDateTime = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  startTime.hour,
                                  startTime.minute
                                );

                                DateTime endDateTime = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  endTime.hour,
                                  endTime.minute
                                );

                                await CalendarFunctions().insert(
                                    title: titleController.text,
                                    description: descriptionController.text,
                                    location: locationController.text,
                                    attendeeList: attendeesList,
                                    notifyAttendees: notifyAttendees,
                                    isConference: isConference,
                                    startTime: startDateTime,
                                    endTime: endDateTime,
                                ).then((Map<String, String> eventData)  async {
                                  print("YE HAI EVENT DATA");
                                  print(eventData);
                                  print("YE BHI HAI MERI ID:" + eventData["id"]);
                                  String eventId = eventData["id"];
                                  String meetLink = eventData["link"];

                                  List<String> emailsList = [];
                                  print("EMAILS KI LIST: ");
                                  print(emailsList);
                                  for(int i=0 ; i<attendeesList.length ; i++){
                                    emailsList.add(attendeesList[i].email);
                                  }

                                  print("EMAILS KI LIST: ");
                                  print(emailsList);

                                  int startTimeSinceEpoch = startDateTime.millisecondsSinceEpoch;
                                  int endTimeSinceEpoch = endDateTime.millisecondsSinceEpoch;

                                  EventModel newEventModel = new EventModel(
                                      id: eventId,
                                      title: titleController.text,
                                      description: descriptionController.text,
                                      location: locationController.text,
                                      startTimeSinceepoch: startTimeSinceEpoch,
                                      endTimeSinceEpoch: endTimeSinceEpoch,
                                      link: meetLink,
                                      emails: emailsList
                                  );

                                  await FirebaseAdd().addEvent(newEventModel);
                                  Navigator.pop(context);
                                });
                              }
                            },
                            child: Center(
                              child: Text(
                                  "CREATE",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    )
                                  ),
                                ),
                            )
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Divider(
        thickness: 2,
        color: mainRedColor,
      ),
    );
  }
}
