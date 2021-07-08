import 'package:flutter/material.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final String location;
  final List<String> emails;
  final int startTimeSinceepoch;
  final int endTimeSinceEpoch;
  final String link;

  EventModel({
    @required this.id,
    this.title,
    this.location,
    this.description,
    this.endTimeSinceEpoch,
    this.startTimeSinceepoch,
    this.emails,
    this.link
  });

  factory EventModel.fromJson(Map<String,dynamic> json){

    List<String> myList = [];
    var jsonList = json["emails"];
    jsonList.forEach((element){
      myList.add(element);
    });
    return EventModel(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      location: json["location"],
      emails: myList,
      startTimeSinceepoch: json["startTime"],
      endTimeSinceEpoch: json["endTime"],
      link: json["link"]
    );
  }

  Map<String,dynamic> toJson(EventModel event){
    return {
      "id": event.id,
      "title": event.title,
      "description": event.description,
      "location": event.location,
      "emails": event.emails,
      "startTime": event.startTimeSinceepoch,
      "endTime": event.endTimeSinceEpoch,
      "link" : event.link
    };
  }

}