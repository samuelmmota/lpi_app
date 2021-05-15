import 'dart:ffi';
import 'dart:io';

import 'package:draw_graph/models/feature.dart';
import 'package:flutter/material.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xiaomi_scale/xiaomi_scale.dart';

final auth = FirebaseAuth.instance;

class Exercice extends StatefulWidget {
  @override
  _ExerciceState createState() => _ExerciceState();
}

class _ExerciceState extends State<Exercice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health App: Exercice'),
        backgroundColor: Colors.lightBlue.shade600,
      ),
      body: MyScreen(),
    );
  }
}

class MyScreen extends StatelessWidget {
  MiScale _mi = MiScale.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<int> _bpmList;
  Future<Null> bpm = FirebaseFirestore.instance
      .collection('BatimentosCardiacos')
      .where('uid', isEqualTo: auth.currentUser.uid)
      .get()
      .then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      print(result.data());
      int aux = result.data().values.skip(1).first;
      print(aux);

      _bpmList.add(result.data().values.skip(1).first);
      //    print("LIST:");
      //   print(_bpmList);
    });
  });

/**Stream<QuerySnapshot> productRef = Firestore.instance
    .collection("stores")
    .document(name)
    .collection("products")
    .snapshots();
productRef.forEach((field) {
  field.documents.asMap().forEach((index, data) {
    productName.add(field.documents[index]["name"]);
  });
}); */
/*
  Stream<QuerySnapshot> stream = FirebaseFirestore.instance
      .collection('BatimentosCardiacos')
      .where('uid', isEqualTo: auth.currentUser.uid)
      .orderBy('time', descending: true)
      .snapshots();
      */
/*

 Future<List> getUserTaskList() async {

    QuerySnapshot qShot = 
      await FirebaseFirestore.instance.collection('userTasks').get();

    return qShot.docs.map(
      (doc) => 
    ).toList();
  }

  main() async {
    List<UserTask> tasks = await getUserTaskList();


  Stream<List> get firebaseStudents {
    return FirebaseFirestore.instance
        .collection('BatimentosCardiacos')
        .snapshots()
        .map(_firebaseStudentsFromSnapshot);
  }

*/

  final List<Feature> features = [
    Feature(
      title: "Grafico de batimentos cardiacos",
      color: Colors.red,
      data: [],
    ),

    /* 

    Feature(
      title: "Exercise",
      color: Colors.pink,
      data: [1, 0.8, 0.6, 0.7, 0.3],
    ),
    Feature(
      title: "Study",
      color: Colors.cyan,
      data: [0.5, 0.4, 0.85, 0.4, 0.7],
    ),
    Feature(
      title: "Water Plants",
      color: Colors.green,
      data: [0.6, 0.2, 0, 0.1, 1],
    ),*/
    Feature(
      title: "BPM",
      color: Colors.red,
      data: [],
    ),
  ];

  const MyScreen({Key key, this._bpmList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 64.0),
          child: Text(
            "Grafos estatisticos",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        LineGraph(
          features: features,
          size: Size(320, 400),
          labelX: ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5'],
          labelY: ['20%', '40%', '60%', '80%', '100%'],
          showDescription: true,
          graphColor: Colors.white30,
          graphOpacity: 0.2,
          verticalFeatureDirection: true,
          descriptionHeight: 130,
        ),
        SizedBox(
          height: 50,
        )
      ],
    );
  }
}

//------------------||-----------------------------
