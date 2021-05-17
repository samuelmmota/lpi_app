import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  static const laranja = 0xFFEE4540;
  static const vermelho_claro = 0xFFC72C41;
  static const vermelho_escuro = 0xFF801336;
  static const purpura = 0xFF510A32;
  static const roxo = 0xFF2D142C;

  @override
  Widget build(BuildContext context) {
    flutterBlue.startScan(timeout: Duration(seconds: 5));
    // Listen to scan results
    var subscription = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
      }
    });

// Stop scanning
    flutterBlue.stopScan();

    return Scaffold(
        appBar: AppBar(
          title: Text('Settings App: Bluethoot'),
          backgroundColor: Color(0xFFC72C41),
        ),
        body: Center(
          child: Text('Settings Screen: mudar aqui o conteudo'),
        ));
  }
}
