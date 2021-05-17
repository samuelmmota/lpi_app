import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpi_app/homePage.dart';
import 'package:lpi_app/src/screens/database/userdata.dart';
import 'package:lpi_app/src/screens/home.dart';

class UserData extends StatelessWidget {
  static const laranja = 0xFFEE4540;
  static const vermelho_claro = 0xFFC72C41;
  static const vermelho_escuro = 0xFF801336;
  static const purpura = 0xFF510A32;
  static const roxo = 0xFF2D142C;
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Bem Vindo: Insere os teus dados!';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,

  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    String _nome, _altura;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome de Utilizador',
                  hintText: 'Insere o teu nome'),

              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                _nome = value;
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Altura',
                  hintText: 'Insere o tua altura'),

              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                _altura = value;
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  _nome = _nome.trim();
                  print("user" + _nome);
                  print("user" + _altura);
                  print("user" + auth.currentUser.uid);
                  print("user" + auth.currentUser.email);

                  //  AddUser(auth.currentUser.uid,_nome,auth.currentUser.email,int.parse(_altura));
                  CollectionReference users =
                      FirebaseFirestore.instance.collection('userData');

                  users
                      .add({
                        'name': _nome, // Johny Sins
                        'uid': auth.currentUser.uid,
                        'email': auth.currentUser.email,
                        'altura': int.parse(_altura),
                      })
                      .then((value) => print(
                          "## Dados do utilizador adiconados à base de dados firebase ##"))
                      .catchError(
                          (error) => print("Failed to add user data: $error"));
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()));

                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('A enviar')));
                }
              },
              child: Text('Guardar dados'),
            ),
          ),
        ],
      ),
    );
  }
}

/*
  Widget displayUserInformation(context, snapshot) {
    final user = snapshot.data;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Name: ${user.displayName ?? 'Anonymous'}", style: TextStyle(fontSize: 20),),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Email: ${user.email ?? 'Anonymous'}", style: TextStyle(fontSize: 20),),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Created: ${DateFormat('MM/dd/yyyy').format(
              user.metadata.creationTime)}", style: TextStyle(fontSize: 20),),
        ),

        showSignOut(context, user.isAnonymous),
      ],
    );
  }

  Widget showSignOut(context, bool isAnonymous) {
    if (isAnonymous == true) {
      return RaisedButton(
        child: Text("Sign In To Save Your Data"),
        onPressed: () {
          Navigator.of(context).pushNamed('/convertUser');
        },
      );
    } else {
      return RaisedButton(
        child: Text("Sign Out"),
        onPressed: () async {
          try {
            await Provider.of(context).auth.signOut();
          } catch (e) {
            print(e);
          }
        },
      );
    }
  }
}
*/
