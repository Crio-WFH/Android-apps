import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart'as calendar;
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:meetup/constants.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';

class CalendarFunctions{

  var client = http.Client();

  void userPrompt(String url) async{
    if(await canLaunch(url)){
      await launch(url);
    }else{
      print("CANNOT LAUNCH" + url);
    }
  }

  Future<Map<String, String>> insert ({
    @required String title,
    @required String description,
    @required String location,
    @required List<calendar.EventAttendee> attendeeList,
    @required bool notifyAttendees,
    @required bool isConference,
    @required DateTime startTime,
    @required DateTime endTime,
  }) async {

    //using calendarId as primary to add event on the primary calendar of the user
    const String calendarID = "primary";
    calendar.Event event = calendar.Event();

    Map<String, String> eventData;

    event.summary = title;
    event.description = description;
    event.attendees = attendeeList;
    event.location = location;

    calendar.EventDateTime startingTime = new calendar.EventDateTime();
    startingTime.dateTime = startTime;
    startingTime.timeZone="GMT+05:30";
    event.start = startingTime;

    calendar.EventDateTime endingTime = new calendar.EventDateTime();
    endingTime.dateTime = endTime;
    endingTime.timeZone = "GMT+05:30";
    event.end = endingTime;

    if(isConference){
      calendar.ConferenceData conferenceData = new calendar.ConferenceData();
      calendar.CreateConferenceRequest conferenceRequest = new calendar.CreateConferenceRequest();

      conferenceRequest.requestId = Uuid().v1();
      conferenceData.createRequest = conferenceRequest;

      event.conferenceData = conferenceData;
    }

    try{
      var clientId = ClientId(ANDROID_CLIENT_KEY, "");
      var scopes =  [calendar.CalendarApi.calendarScope];
      await clientViaUserConsent(clientId, scopes, userPrompt).then((AuthClient client) async{
        var cal = calendar.CalendarApi(client);
        await cal.events.insert(
            event,
            calendarID,
            conferenceDataVersion: isConference? 1:0,
            sendUpdates: notifyAttendees?"all": "none").then((value){
          if(value.status == "confirmed"){

            String eventId;
            String meetLink;

            eventId = value.id;
            print("YE HAI MERI ID" + eventId);
            if(isConference){
              meetLink = "https://meet.google.com/${value.conferenceData.conferenceId}";
            }

            eventData = {"id": eventId, "link": meetLink};

            print(eventData["id"]);
            print(eventData["link"]);
            print("Event Added succesfully");

          }else{
            print("Error in adding event");
          }

//          return eventData;
        });
      });
    }catch(e){
      print ("Error" + e.toString());
    }
    return eventData;
  }
}