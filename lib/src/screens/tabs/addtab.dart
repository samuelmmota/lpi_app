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
                color: Colors.lightBlue.shade600,
              ),
              helperText: 'ex: 120',
              suffixIcon: Icon(
                Icons.check_circle,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.lightBlue.shade600),
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
