import 'package:flutter/material.dart';
import 'package:lpi_app/src/screens/login.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        accentColor: Colors.orange,
        primarySwatch: Colors.blue
      ),
      home: LoginScreen(),
    );
  }
}
