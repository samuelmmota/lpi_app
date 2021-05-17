import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xiaomi_scale/xiaomi_scale.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final auth = FirebaseAuth.instance;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with AutomaticKeepAliveClientMixin<Dashboard> {
  MiScale _mi = MiScale.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool get wantKeepAlive => true;

  static const laranja = 0xFFEE4540;
  static const vermelho_claro = 0xFFC72C41;
  static const vermelho_escuro = 0xFF801336;
  static const purpura = 0xFF510A32;
  static const roxo = 0xFF2D142C;

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    //CollectionReference users = FirebaseFirestore.instance.collection('userData');
    //Stream collectionStream = FirebaseFirestore.instance.collection('userData').snapshots();
    print(
        "<#################################################################utilizador: " +
            auth.currentUser.uid);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFC72C41),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                indicatorColor: Color(0xFF2D142C),
                indicatorSize: TabBarIndicatorSize.tab,
                isScrollable: true,
                indicatorWeight: 5,
                /*indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), // Creates border
                    color: Colors.greenAccent),*/
                tabs: [
                  Tab(child: Text('BPM DATA')),
                  Tab(child: Text('IMC DATA')),
                  Tab(child: Text('Peso DATA')),
                  Tab(child: Text('TENSAO DATA')),
                ],
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            BpmData(),
            ImcData(),
            PesoData(),
            TensaoData(),
          ],
        ),
      ),

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

class BpmData extends StatelessWidget {
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

class ImcData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Query bpm = FirebaseFirestore.instance
        .collection('IMC')
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
              title: new Text("IMC[" + dateNow.toString() + "]:"),
              subtitle: new Text(document.data()['valor'].toString()),
            );
          }).toList(),
        );
      },
    );
  }
}

class PesoData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Query bpm = FirebaseFirestore.instance
        .collection('weight')
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

class TensaoData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Query bpm = FirebaseFirestore.instance
        .collection('tensao')
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
