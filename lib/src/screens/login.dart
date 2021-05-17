import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lpi_app/src/screens/home.dart';
import 'package:lpi_app/src/screens/register.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser != null)
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login em Healhapp"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('images/heart_logo.png')),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Insere a password'),
                onChanged: (value) {
                  setState(() {
                    _password = value.trim();
                  });
                },
              ),
            ),
            FlatButton(
              onPressed: () {
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Esqueci a minha Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                onPressed: () async {
                  await auth.signInWithEmailAndPassword(
                      email: _email, password: _password);
                  print('###Inicio de sessão com sucesso no User: ' +
                      auth.currentUser.email +
                      '(cID:' +
                      auth.currentUser.uid +
                      ')###');
                  if (auth.currentUser != null) {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }
                  /*Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HomeScreen()));*/
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),

            //Text('Novo utilizador? Criar Conta'),
            FlatButton(
              child: Text('Novo utilizador? Criar Conta',
                  style: TextStyle(
                    color: Colors.blue,
                  )),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => RegisterScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

/*
appBar: AppBar(
        title: Text('login'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: 'Email'),
              onChanged: (value) {
                setState(() {
                  _email = value.trim();

                });
              },
            ),
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(hintText: 'Palavra pass (should be at least 6 characters)'),
            onChanged: (value) {
              setState(() {
                _password = value.trim();
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text('Login'),
                  onPressed: () {
                    auth.signInWithEmailAndPassword(email: _email, password: _password);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomeScreen()));
                  }),
              RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text('Registar'),
                  onPressed: () {
                    auth.createUserWithEmailAndPassword(email: _email, password: _password);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomeScreen()));
//função vazia
                  })
            ],
          )
        ],
      ),
    );
  }
}
*/
