import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meetup/models/eventModel.dart';
import 'package:flutter/material.dart';
import 'package:meetup/models/groupModel.dart';

class FirebaseAdd{

  addEvent(EventModel event) async{
    CollectionReference events = FirebaseFirestore.instance.collection('events');
    await events.doc(event.id).set(event.toJson(event)).whenComplete(() {
      print("EVENT SUCCESSFULLY ADDED TO FIRESTORE");
    }).catchError((e){
      print(e);
    });
  }


  addGroup(Group group) async{
    CollectionReference groups = FirebaseFirestore.instance.collection('groups');
    await groups.doc(group.groupName).set(group.toJson(group)).whenComplete(() {
      print("GROUP ADDED TO FIREBASE SUCCESSFULLY");
    }).catchError((e){
      print(e);
    });
  }

  getGroupsNamesList() async{
    List<String> groupNames = [];

    CollectionReference groups = FirebaseFirestore.instance.collection("groups");
    var getDocs = groups.get().then((value){
      var docs = value.docs.map((e) => e.data());
      docs.forEach((element) {
        Group newGroup = Group.fromJson(element);
        groupNames.add(newGroup.groupName);
      });
      print(groupNames);
    });

    return groupNames;
  }

  getGroupEmailsList(String name) async{
    List<String> groupEmails = [];
    CollectionReference groups = FirebaseFirestore.instance.collection("groups");
    var getDocs = groups.where("groupName" , isEqualTo: name).get().then((value){
      var docs = value.docs.map((e) => e.data());
      docs.forEach((element) {
        Group newGroup = Group.fromJson(element);
        newGroup.emailsList.forEach((element) {
          groupEmails.add(element);
        });
      });
      print(groupEmails);
    });
  }
}