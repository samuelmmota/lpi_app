import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  FlutterBlue flutterBlue = FlutterBlue.instance;

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
          backgroundColor: Colors.lightBlue.shade600,
        ),
        body:Center(
          child:Text('Settings Screen: mudar aqui o conteudo') ,
        )


    );
  }
}
