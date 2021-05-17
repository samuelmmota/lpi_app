import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddTab extends StatefulWidget {
  @override
  _AddTabState createState() => _AddTabState();
}

class _AddTabState extends State<AddTab> {
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  static const laranja = 0xFFEE4540;
  static const vermelho_claro = 0xFFC72C41;
  static const vermelho_escuro = 0xFF801336;
  static const purpura = 0xFF510A32;
  static const roxo = 0xFF2D142C;

  @override
  Widget build(BuildContext context) {
    String _bpm;
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
              labelText: 'Batimentos Cardiacos <3',
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
                  print("-> bpm: " + _bpm);
                  _bpm = _bpm.trim();

                  //  AddUser(auth.currentUser.uid,_nome,auth.currentUser.email,int.parse(_altura));
                  CollectionReference bpms = FirebaseFirestore.instance
                      .collection('BatimentosCardiacos');

                  bpms.add({
                    'uid': auth.currentUser.uid,
                    'valor': int.parse(_bpm),
                    "time": Timestamp.now(),
                    // "time": FieldValue.serverTimestamp(),
                    // "time": firebase.firestore.FieldValue.serverTimestamp(),,
                  }).then((value) => print(
                      "## Dados do utilizador adiconados à base de dados firebase ##"));
                  // Validate returns true if the form is valid, or false otherwise.
                  if (!_formKey.currentState.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')));
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
}
