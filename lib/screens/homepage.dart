
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_firestore_crud/screens/addStudentPage.dart';
import 'package:flutter_firestore_crud/screens/listStudentPage.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Flutter Firestore CRUD"),
            ElevatedButton(onPressed: (){
             Get.to(AddStudentPage());
            },style: ElevatedButton.styleFrom(
              primary: Colors.purple
            ), child: Text("Add")
          )
          ],
        ),
      ),
      body: ListStudentPage(),
    );
  }
}