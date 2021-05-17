import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;

class AddTab extends StatefulWidget {
  @override
  _AddTabState createState() => _AddTabState();
}

class _AddTabState extends State<AddTab> {
  // final _formKey = GlobalKey<FormState>();

  static const laranja = 0xFFEE4540;
  static const vermelho_claro = 0xFFC72C41;
  static const vermelho_escuro = 0xFF801336;
  static const purpura = 0xFF510A32;
  static const roxo = 0xFF2D142C;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _BpmText(context),
          _ImcText(context),
          _WheightText(context),
          _TensaoText(context)
        ],
      ),
    );
  }
}

Widget _ImcText(BuildContext context) {
  String _imc;
  final _formKey = GlobalKey<FormState>();
  // BPM
  return Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          cursorColor: Theme.of(context).cursorColor,
          maxLength: 20,
          decoration: InputDecoration(
            icon: Icon(Icons.favorite),
            labelText: 'Indice Massa Corporal',
            labelStyle: TextStyle(
              color: Color(0xFFC72C41),
            ),
            helperText: 'ex: 120',
            suffixIcon: Icon(
              Icons.check_circle,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFC72C41)),
            ),
          ),
          validator: (value) {
            if ((value == null || value.isEmpty) && int.parse(value) <= 0 ||
                int.parse(value) >= 300) {
              return 'Please enter some valid number';
            } else {
              _imc = value;
              return null;
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Color(0xFF510A32)),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                print("-> user: " + auth.currentUser.uid);
                print("-> imc: " + _imc);
                _imc = _imc.trim();

                //  AddUser(auth.currentUser.uid,_nome,auth.currentUser.email,int.parse(_altura));
                CollectionReference imcs =
                    FirebaseFirestore.instance.collection('IMC');

                imcs.add({
                  'uid': auth.currentUser.uid,
                  'valor': int.parse(_imc),
                  "time": Timestamp.now(),
                  // "time": FieldValue.serverTimestamp(),
                  // "time": firebase.firestore.FieldValue.serverTimestamp(),,
                }).then((value) => print(
                    "## Dados do imc adiconados à base de dados firebase ##"));
                // Validate returns true if the form is valid, or false otherwise.
                if (!_formKey.currentState.validate()) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              }
            },
            child: Text('Submit'),
          ),
        ),
      ],
    ),
  );
}

Widget _WheightText(BuildContext context) {
  String _weight;
  final _formKey = GlobalKey<FormState>();
  // BPM
  return Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // weight
        TextFormField(
          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          cursorColor: Theme.of(context).cursorColor,
          maxLength: 20,
          decoration: InputDecoration(
            icon: Icon(Icons.favorite),
            labelText: 'Inserir peso corporal',
            labelStyle: TextStyle(
              color: Color(0xFFC72C41),
            ),
            helperText: 'ex: 120',
            suffixIcon: Icon(
              Icons.check_circle,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFC72C41)),
            ),
          ),
          validator: (value) {
            if ((value == null || value.isEmpty) && int.parse(value) <= 0 ||
                int.parse(value) >= 300) {
              return 'Please enter some valid number';
            } else {
              _weight = value;
              return null;
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Color(0xFF510A32)),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                print("-> user: " + auth.currentUser.uid);
                print("-> imc: " + _weight);
                _weight = _weight.trim();

                //  AddUser(auth.currentUser.uid,_nome,auth.currentUser.email,int.parse(_altura));
                CollectionReference weights =
                    FirebaseFirestore.instance.collection('weight');

                weights.add({
                  'uid': auth.currentUser.uid,
                  'valor': int.parse(_weight),
                  "time": Timestamp.now(),
                  // "time": FieldValue.serverTimestamp(),
                  // "time": firebase.firestore.FieldValue.serverTimestamp(),,
                }).then((value) => print(
                    "## Dados do weight adiconados à base de dados firebase ##"));
                // Validate returns true if the form is valid, or false otherwise.
                if (!_formKey.currentState.validate()) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              }
            },
            child: Text('Submit'),
          ),
        ),
      ],
    ),
  );
}

Widget _TensaoText(BuildContext context) {
  String _tensao;
  final _formKey = GlobalKey<FormState>();
  // BPM
  return Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // weight
        // tensao
        TextFormField(
          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          cursorColor: Theme.of(context).cursorColor,
          maxLength: 20,
          decoration: InputDecoration(
            icon: Icon(Icons.favorite),
            labelText: 'Inserir valor de tensão',
            labelStyle: TextStyle(
              color: Color(0xFFC72C41),
            ),
            helperText: 'ex: 120',
            suffixIcon: Icon(
              Icons.check_circle,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFC72C41)),
            ),
          ),
          validator: (value) {
            if ((value == null || value.isEmpty) && int.parse(value) <= 0 ||
                int.parse(value) >= 300) {
              return 'Please enter some valid number';
            } else {
              _tensao = value;
              return null;
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Color(0xFF510A32)),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                print("-> user: " + auth.currentUser.uid);
                print("-> tensao: " + _tensao);
                _tensao = _tensao.trim();

                //  AddUser(auth.currentUser.uid,_nome,auth.currentUser.email,int.parse(_altura));
                CollectionReference tensoes =
                    FirebaseFirestore.instance.collection('tensao');

                tensoes.add({
                  'uid': auth.currentUser.uid,
                  'valor': int.parse(_tensao),
                  "time": Timestamp.now(),
                  // "time": FieldValue.serverTimestamp(),
                  // "time": firebase.firestore.FieldValue.serverTimestamp(),,
                }).then((value) => print(
                    "## Dados do tensao adiconados à base de dados firebase ##"));
                // Validate returns true if the form is valid, or false otherwise.
                if (!_formKey.currentState.validate()) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              }
            },
            child: Text('Submit'),
          ),
        ),
      ],
    ),
  );
}

Widget _BpmText(BuildContext context) {
  String _bpm;
  final _formKey = GlobalKey<FormState>();
  // BPM
  return Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          cursorColor: Theme.of(context).cursorColor,
          maxLength: 20,
          decoration: InputDecoration(
            icon: Icon(Icons.favorite),
            labelText: 'Batimentos Cardiacos',
            labelStyle: TextStyle(
              color: Color(0xFFC72C41),
            ),
            helperText: 'ex: 120',
            suffixIcon: Icon(
              Icons.check_circle,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFC72C41)),
            ),
          ),
          validator: (value) {
            if ((value == null || value.isEmpty) && int.parse(value) <= 0 ||
                int.parse(value) >= 300) {
              return 'Please enter some valid number';
            } else {
              _bpm = value;
              return null;
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Color(0xFF510A32)),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                print("-> user: " + auth.currentUser.uid);
                print("-> _bpm: " + _bpm);
                _bpm = _bpm.trim();

                //  AddUser(auth.currentUser.uid,_nome,auth.currentUser.email,int.parse(_altura));
                CollectionReference imcs = FirebaseFirestore.instance
                    .collection('BatimentosCardiacos');

                imcs.add({
                  'uid': auth.currentUser.uid,
                  'valor': int.parse(_bpm),
                  "time": Timestamp.now(),
                  // "time": FieldValue.serverTimestamp(),
                  // "time": firebase.firestore.FieldValue.serverTimestamp(),,
                }).then((value) => print(
                    "## Dados do _bpm adiconados à base de dados firebase ##"));
                // Validate returns true if the form is valid, or false otherwise.
                if (!_formKey.currentState.validate()) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              }
            },
            child: Text('Submit'),
          ),
        ),
      ],
    ),
  );
}
