
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firestore_crud/screens/updateStudent.dart';

class ListStudentPage extends StatefulWidget {
  const ListStudentPage({ Key? key }) : super(key: key);

  @override
  _ListStudentPageState createState() => _ListStudentPageState();
}

class _ListStudentPageState extends State<ListStudentPage> {

  final Stream<QuerySnapshot> studentStream = FirebaseFirestore.instance.collection('students').snapshots();

  CollectionReference student = FirebaseFirestore.instance.collection('students');

  Future <void>deleteUser(id){
    return student
      .doc(id)
      .delete()
      .then((value) => print("User DELETED"))
      .catchError((error) => print("User NOT DELETED$error"));
  }


  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
      return StreamBuilder(
        stream: studentStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return Text("Something is wrong");
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final List storedoc = [];
          snapshot.data!.docs.map((DocumentSnapshot document){
            Map a = document.data() as Map<String, dynamic>;
            storedoc.add(a);
            a['id'] = document.id;
          }).toList();

          return Scaffold(
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Table(
                  border: TableBorder.all(),
                  columnWidths: <int, TableColumnWidth>{
                    1: FixedColumnWidth(160)
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            color: Colors.greenAccent,
                            child: Center(
                              child: Text("Name", style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold
                              )),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            color: Colors.greenAccent,
                            child: Center(
                              child: Text("Email", style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold
                              )),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            color: Colors.greenAccent,
                            child: Center(
                              child: Text("Action", style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold
                              )),
                            ),
                          ),
                        )
                      ]
                    ),
                    for(var i=0; i < storedoc.length; i++)...[
                    TableRow(
                      children: [
                        TableCell(
                          child: Center(
                            child: Text(storedoc[i]['name'], style: TextStyle(
                              fontSize: 18.0, 
                            )),
                          ),
                        ),
                        TableCell(
                          child: Center(
                            child: Text(storedoc[i]['email'], style: TextStyle(
                              fontSize: 18.0, 
                            )),
                          ),
                        ),
                        TableCell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(onPressed: (){
                                Navigator.push(
                                  context, MaterialPageRoute(
                                    builder: (context)=>UpdateStudent(
                                      id: storedoc[i]['id']
                                    )
                                  )
                                );
                              },icon: Icon(Icons.edit, color: Colors.orange,)),
                              IconButton(onPressed: (){
                                deleteUser(storedoc[i]['id']);
                              },icon: Icon(Icons.delete, color: Colors.red,))
                            ],
                          )
                        )
                      ]
                    )
                  ],
                ]
                ),
              ),
            )
          );
        }
      );  
   }
}
