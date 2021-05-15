import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xiaomi_scale/xiaomi_scale.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final auth = FirebaseAuth.instance;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  MiScale _mi = MiScale.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    //CollectionReference users = FirebaseFirestore.instance.collection('userData');
    //Stream collectionStream = FirebaseFirestore.instance.collection('userData').snapshots();
    print(
        "<#################################################################utilizador: " +
            auth.currentUser.uid);
    return Scaffold(
      appBar: AppBar(
        title: Text('Health App: DashBoard'),
        backgroundColor: Colors.lightBlue.shade600,
      ),
      body: UserData(),

      /*Table(
        columnWidths: {2:FlexColumnWidth(.5)},
          //child:
              //Text('Dashnoard Screen: mudar aqui o conteudo') ,
            border: TableBorder.all(),
        children: [
          TableRow(children: [
            Text('Name',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
            Text('Surname',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
            Text('Age',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),

          ]),
          TableRow(children: [
            Text('Name',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
            Text('Surname',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
            Text('Age',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),

          ]),
        ],
      ),*/
    );
  }
}

class UserData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Query bpm = FirebaseFirestore.instance
        .collection('BatimentosCardiacos')
        .where('uid', isEqualTo: auth.currentUser.uid);
    //  .orderBy('time', descending: true);

    return StreamBuilder<QuerySnapshot>(
      stream: bpm.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return new ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            DateTime dateNow = document.data()['time'].toDate();

            return new ListTile(
              title: new Text("BPM[" + dateNow.toString() + "]:"),
              subtitle: new Text(document.data()['valor'].toString()),
            );
          }).toList(),
        );
      },
    );
  }
}
