import 'package:flutter/material.dart';
import 'package:meetup/utils/firebaseHandler.dart';
import 'package:meetup/widgets/customTextField.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetup/constants.dart';
import 'package:meetup/models/groupModel.dart';

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final emailFormKey = GlobalKey<FormState>();
  final groupFormKey = GlobalKey<FormState>();
  final nameController = new TextEditingController();
  final emailController = new TextEditingController();
  List<String> emailsList = [];

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainRedColor,
        centerTitle: true,
        title: Text(
          "Create A Group",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Colors.white
            )
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: [
          Form(
            key: groupFormKey,
            child: CustomTextField(
                myController: nameController,
                hint: "Group Name"
            ),
          ),
          SizedBox(
            height: 10,
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
                        emailsList.add(emailController.text);
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
            height: 10,
          ),
          Visibility(
            visible: emailsList.length>0,
            child: Text(
              "Members:",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: matteBlack,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: emailsList.length,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context,index){
                  return Text(
                    emailsList[index],
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: matteBlack,
                            fontSize: 18
                        )
                    ),
                  );
                }
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: width*0.7,
            child: TextButton(
              onPressed: () async{
                Group group = new Group(
                  groupName: nameController.text,
                  emailsList: emailsList
                );

                await FirebaseAdd().addGroup(group);

                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: mainRedColor
              ),
              child: Center(
                child: Text(
                  "CREATE",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
