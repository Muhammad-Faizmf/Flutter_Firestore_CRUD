
// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateStudent extends StatefulWidget {
  final String id;

  const UpdateStudent({ Key? key,required this.id }) : super(key: key);

  @override
  _UpadateStudentState createState() => _UpadateStudentState();
}

class _UpadateStudentState extends State<UpdateStudent> {

  final _formkey = GlobalKey<FormState>();

  bool obscureText = true;

  CollectionReference student = FirebaseFirestore.instance.collection('students');

  Future<void> updateUser(id, name, email, password){
    return student
    .doc(id)
    .update({'name': name, 'email':email, 'password': password})
    .then((value) => print("User UPDATED"))
    .catchError((error) => print("User NOT UPDATED$error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Student"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formkey,
          child: FutureBuilder<DocumentSnapshot<Map<String,dynamic>>>(
            future: FirebaseFirestore.instance.collection('students')
            .doc(widget.id)
            .get(),
            builder: (_, snapshot){
              if(snapshot.hasError){
                return Text("Something is wrong");
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }
              var data = snapshot.data!.data();
              var name = data!['name'];
              var email = data['email'];
              var password = data['password'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      initialValue: name,
                      onChanged: (value) => name=value,
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
                      initialValue: email,
                      onChanged: (value) => email=value,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Email",
                        errorStyle: TextStyle(
                          fontSize: 13.0
                        ),
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
                      initialValue: password,
                      onChanged: (value) => password=value,
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Password",
                        errorStyle: TextStyle(
                          fontSize: 13.0
                        ),
                        suffixIcon: IconButton(onPressed: (){
                          setState(() {
                            obscureText = !obscureText;
                          });
                        }, icon:Icon(obscureText ? Icons.visibility_off : Icons.visibility))
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
                          updateUser(widget.id, name, email, password);
                          Get.back();
                        }, child: const Text("Update")),
                        ElevatedButton(onPressed: (){
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey
                        ), child: Text("Reset"),)
                      ],
                    )
                 ],
               );
            }
          )
        ),
      )
    );
  }
}



