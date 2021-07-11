import 'package:flutter/material.dart';

class Group{
  final String groupName;
  final List<String> emailsList;

  Group({
    this.groupName,
    this.emailsList
  });

  factory Group.fromJson(Map<String,dynamic> json){
    List<String> myList = [];
    var jsonList = json["emailsList"];
    jsonList.forEach((element){
      myList.add(element);
    });

    return Group(
      groupName: json["groupName"],
      emailsList: myList
    );
  }

  Map<String,dynamic> toJson(Group group){
    return{
      "groupName": group.groupName,
      "emailsList": group.emailsList
    };
  }
}