
// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({ Key? key }) : super(key: key);

  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {

  var name = "";
  var password = "";
  var email = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController(); 

  final _formkey = GlobalKey<FormState>();

  CollectionReference student = FirebaseFirestore.instance.collection('students');

  cleatText(){
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  Future<void> addUser(){
    return student
    .add({'name' : name, 'email' : email, 'password' : password})
    .then((value) => print("User ADDED"))
    .catchError((error) => print("User NOT ADDED$error"));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Student"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formkey,
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Name",
                  errorStyle: TextStyle(
                    fontSize: 13.0
                  )
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Please enter name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Email",
                  errorStyle: TextStyle(
                    fontSize: 13.0
                  )
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Please enter email";
                  }
                  else if(!value.contains("@gmail.com")){
                    return "Please enter a valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Password",
                  errorStyle: TextStyle(
                    fontSize: 13.0
                  )
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Please enter password";
                  }
                  else if(value.length < 6){
                    return "Password length should be 6.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: (){
                    if(_formkey.currentState!.validate()){
                      setState(() {
                        name = nameController.text;
                        email = emailController.text;
                        password = passwordController.text;
                      });
                      addUser();
                      cleatText();
                    }
                  }, child: const Text("Register")),
                  ElevatedButton(onPressed: (){
                    cleatText();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey
                  ), child: const Text("Reset"),)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}