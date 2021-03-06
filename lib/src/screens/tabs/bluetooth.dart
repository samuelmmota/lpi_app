import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:xiaomi_scale/xiaomi_scale.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final auth = FirebaseAuth.instance;

class Bluetooth extends StatefulWidget {
  @override
  _BluetoothState createState() => _BluetoothState();
}

FlutterBlue flutterBlue = FlutterBlue.instance;

class _BluetoothState extends State<Bluetooth> {
  var _currentIndex = 0;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  MiScale _mi = MiScale.instance;
  static const laranja = 0xFFEE4540;
  static const vermelho_claro = 0xFFC72C41;
  static const vermelho_escuro = 0xFF801336;
  static const purpura = 0xFF510A32;
  static const roxo = 0xFF2D142C;
/*
  @override
  Widget build(BuildContext context) {
// Start scanning
    flutterBlue.startScan(timeout: Duration(seconds: 4));

// Listen to scan results
    var subscription = flutterBlue.scanResults.listen((device) {
      // do something with scan results
      for (ScanResult r in device) {
        print('${r.device.name} found! rssi: ${r.rssi}');
      }
    });

      connect(device);
// Stop scanning
    flutterBlue.stopScan();

// Connect to the device
    //await device.connect();

// Disconnect from device
    // device.disconnect();

    return Scaffold(
        appBar: AppBar(
          title: Text('Conection with: Bluethoot'),
          backgroundColor: Color(0xFFC72C41),
        ),
        body: Center(
          child: Text('Settings Screen: mudar aqui o conteudo'),
        ));
  }
}
*/
/*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Scale Example App'),
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            MeasurementPane(),
            ScanningPane(),
            RawDataPane(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _bottomTapped,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black26,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.timeline),
              label: 'Measurements',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Scanning',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description),
              label: 'Raw Data',
            ),
          ],
        ),
      ),
    );
  }

  void _bottomTapped(int index) => setState(() => _currentIndex = index);
}

class ScanningPane extends StatefulWidget {
  @override
  _ScanningPaneState createState() => _ScanningPaneState();
}

class _ScanningPaneState extends State<ScanningPane> {
  StreamSubscription _scanSubscription;
  Map<String, MiScaleDevice> devices = {}; // <Id, MiScaleDevice>
  final _scale = MiScale.instance;

  @override
  void dispose() {
    stopDiscovery(dispose: true);
    super.dispose();
  }

  Future<void> startDiscovery() async {
    // Make sure we have location permission required for BLE scanning
    // if (!await checkPermission()) return;
    // Clear device list
    devices = {};
    // Start scanning
    setState(() {
      _scanSubscription = _scale.discoverDevices().listen(
        (device) {
          print(device);
          setState(() {
            devices[device.id] = device;
          });
        },
        onError: (e) {
          print(e);
          stopDiscovery();
        },
        onDone: stopDiscovery,
      );
    });
  }

  void stopDiscovery({dispose = false}) {
    _scanSubscription?.cancel();
    _scanSubscription = null;
    if (!dispose) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Start Scanning'),
              onPressed: _scanSubscription == null ? startDiscovery : null,
            ),
            ElevatedButton(
              child: const Text('Stop Scanning'),
              onPressed: _scanSubscription != null ? stopDiscovery : null,
            ),
          ],
        ),
        Opacity(
          opacity: _scanSubscription != null ? 1 : 0,
          child: const Center(child: CircularProgressIndicator()),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: devices.values.map(_buildDeviceWidget).toList(),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildDeviceWidget(MiScaleDevice device) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Name: ${device.name}'),
                  Text('Device ID: ${device.id}'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('RSSI: ${device.rssi}dBm'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RawDataPane extends StatefulWidget {
  @override
  _RawDataPaneState createState() => _RawDataPaneState();
}

class _RawDataPaneState extends State<RawDataPane> {
  StreamSubscription _dataSubscription;
  List<MiScaleData> scaleData = [];
  final _scale = MiScale.instance;

  @override
  void dispose() {
    super.dispose();
    stopTakingData(dispose: true);
  }

  Future<void> startTakingData() async {
    // Make sure we have location permission required for BLE scanning
    //  if (!await checkPermission()) return;
    // Start taking measurements
    setState(() {
      _dataSubscription = _scale.readScaleData().listen(
        (data) {
          setState(() {
            scaleData.insert(0, data);
            if (scaleData.length > 10) scaleData.removeLast();
          });
        },
        onError: (e) {
          print(e);
          stopTakingData();
        },
        onDone: stopTakingData,
      );
    });
  }

  void stopTakingData({dispose = false}) {
    _dataSubscription?.cancel();
    _dataSubscription = null;
    if (!dispose) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Start Reading'),
              onPressed: _dataSubscription == null ? startTakingData : null,
            ),
            ElevatedButton(
              child: const Text('Stop Reading'),
              onPressed: _dataSubscription != null ? stopTakingData : null,
            ),
          ],
        ),
        Opacity(
          opacity: _dataSubscription != null ? 1 : 0,
          child: const Center(child: CircularProgressIndicator()),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Last 10 readings:'),
                ...scaleData.map(_buildScaleDataWidget),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildScaleDataWidget(MiScaleData data) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(data.toString()),
      ),
    );
  }
}

class MeasurementPane extends StatefulWidget {
  @override
  _MeasurementPaneState createState() => _MeasurementPaneState();
}

class _MeasurementPaneState extends State<MeasurementPane> {
  StreamSubscription _measurementSubscription;
  Map<String, MiScaleMeasurement> measurements = {}; // <Id, Measurement>
  final _scale = MiScale.instance;

  @override
  void dispose() {
    super.dispose();
    stopTakingMeasurements(dispose: true);
  }

  Future<void> startTakingMeasurements() async {
    // Make sure we have location permission required for BLE scanning
    //if (!await checkPermission()) return;
    // Start taking measurements
    setState(() {
      _measurementSubscription = _scale.takeMeasurements().listen(
        (measurement) {
          setState(() {
            measurements[measurement.id] = measurement;
          });
        },
        onError: (e) {
          print(e);
          stopTakingMeasurements();
        },
        onDone: stopTakingMeasurements,
      );
    });
  }

  void stopTakingMeasurements({dispose = false}) {
    _measurementSubscription?.cancel();
    _measurementSubscription = null;
    if (!dispose) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ElevatedButton(
                child: const Text(
                  'Start Taking Measurements',
                  textAlign: TextAlign.center,
                ),
                onPressed: _measurementSubscription == null
                    ? startTakingMeasurements
                    : null,
              ),
            ),
            Expanded(
              child: ElevatedButton(
                child: const Text(
                  'Stop Taking Measurements',
                  textAlign: TextAlign.center,
                ),
                onPressed: _measurementSubscription != null
                    ? stopTakingMeasurements
                    : null,
              ),
            ),
          ],
        ),
        Opacity(
          opacity: _measurementSubscription != null ? 1 : 0,
          child: const Center(child: CircularProgressIndicator()),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children:
                  measurements.values.map(_buildMeasurementWidget).toList(),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildMeasurementWidget(MiScaleMeasurement measurement) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    measurement.weight.toStringAsFixed(2) +
                        measurement.unit.toString().split('.')[1],
                  ),
                  Text(
                    measurement.stage.toString().split('.')[1],
                  ),
                  Text(
                    measurement.dateTime.toIso8601String(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                final deviceId = measurement.deviceId;
                // Cancel the measurement if it is still active
                if (measurement.isActive && deviceId != null)
                  _scale.cancelMeasurement(deviceId);
                // Remove the measurement from the list
                setState(() {
                  measurements.remove(measurement.id);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Color(vermelho_escuro),
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);
  static const laranja = 0xFFEE4540;
  static const vermelho_claro = 0xFFC72C41;
  static const vermelho_escuro = 0xFF801336;
  static const purpura = 0xFF510A32;
  static const roxo = 0xFF2D142C;
  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(vermelho_escuro),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Devices'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map((d) => ListTile(
                            title: Text(d.name),
                            subtitle: Text(d.id.toString()),
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: d.state,
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (c, snapshot) {
                                if (snapshot.data ==
                                    BluetoothDeviceState.connected) {
                                  return RaisedButton(
                                    child: Text('OPEN'),
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DeviceScreen(device: d))),
                                  );
                                }
                                return Text(snapshot.data.toString());
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map(
                        (r) => ScanResultTile(
                          result: r,
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            r.device.connect();
                            return DeviceScreen(device: r.device);
                          })),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key key, this.device}) : super(key: key);

  final BluetoothDevice device;

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services
        .map(
          (s) => ServiceTile(
            service: s,
            characteristicTiles: s.characteristics
                .map(
                  (c) => CharacteristicTile(
                    characteristic: c,
                    onReadPressed: () => c.read(),
                    onWritePressed: () async {
                      await c.write(_getRandomBytes(), withoutResponse: true);
                      await c.read();
                    },
                    onNotificationPressed: () async {
                      await c.setNotifyValue(!c.isNotifying);
                      await c.read();
                    },
                    descriptorTiles: c.descriptors
                        .map(
                          (d) => DescriptorTile(
                            descriptor: d,
                            onReadPressed: () => d.read(),
                            onWritePressed: () => d.write(_getRandomBytes()),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => {
                        device.disconnect(),
                        print("CHEGUEI AQUI"),
                        randomDataBPM(),
                      };
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => {
                        device.connect(),
                      };
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return FlatButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .button
                        ?.copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) => ListTile(
                leading: (snapshot.data == BluetoothDeviceState.connected)
                    ? Icon(Icons.bluetooth_connected)
                    : Icon(Icons.bluetooth_disabled),
                title: Text(
                    'Device is ${snapshot.data.toString().split('.')[1]}.'),
                subtitle: Text('${device.id}'),
                trailing: StreamBuilder<bool>(
                  stream: device.isDiscoveringServices,
                  initialData: false,
                  builder: (c, snapshot) => IndexedStack(
                    index: snapshot.data ? 1 : 0,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () => device.discoverServices(),
                      ),
                      IconButton(
                        icon: SizedBox(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.grey),
                          ),
                          width: 18.0,
                          height: 18.0,
                        ),
                        onPressed: null,
                      )
                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder<int>(
              stream: device.mtu,
              initialData: 0,
              builder: (c, snapshot) => ListTile(
                title: Text('MTU Size'),
                subtitle: Text('${snapshot.data} bytes'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => device.requestMtu(223),
                ),
              ),
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: device.services,
              initialData: [],
              builder: (c, snapshot) {
                return Column(
                  children: _buildServiceTiles(snapshot.data),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key key, this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  final VoidCallback onTap;

  Widget _buildTitle(BuildContext context) {
    if (result.device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            result.device.name,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            result.device.id.toString(),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      return Text(result.device.id.toString());
    }
  }

  Widget _buildAdvRow(BuildContext context, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.caption),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.apply(color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
        .toUpperCase();
  }

  String getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(
          '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  String getNiceServiceData(Map<String, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add('${id.toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: _buildTitle(context),
      leading: Text(result.rssi.toString()),
      trailing: RaisedButton(
        child: Text('CONNECT'),
        color: Colors.black,
        textColor: Colors.white,
        onPressed: (result.advertisementData.connectable) ? onTap : null,
      ),
      children: <Widget>[
        _buildAdvRow(
            context, 'Complete Local Name', result.advertisementData.localName),
        _buildAdvRow(context, 'Tx Power Level',
            '${result.advertisementData.txPowerLevel ?? 'N/A'}'),
        _buildAdvRow(context, 'Manufacturer Data',
            getNiceManufacturerData(result.advertisementData.manufacturerData)),
        _buildAdvRow(
            context,
            'Service UUIDs',
            (result.advertisementData.serviceUuids.isNotEmpty)
                ? result.advertisementData.serviceUuids.join(', ').toUpperCase()
                : 'N/A'),
        _buildAdvRow(context, 'Service Data',
            getNiceServiceData(result.advertisementData.serviceData)),
      ],
    );
  }
}

class ServiceTile extends StatelessWidget {
  final BluetoothService service;
  final List<CharacteristicTile> characteristicTiles;

  const ServiceTile({Key key, this.service, this.characteristicTiles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (characteristicTiles.length > 0) {
      return ExpansionTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Service'),
            Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}',
                style: Theme.of(context).textTheme.body1?.copyWith(
                    color: Theme.of(context).textTheme.caption?.color))
          ],
        ),
        children: characteristicTiles,
      );
    } else {
      return ListTile(
        title: Text('Service'),
        subtitle:
            Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}'),
      );
    }
  }
}

class CharacteristicTile extends StatelessWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;
  final VoidCallback onReadPressed;
  final VoidCallback onWritePressed;
  final VoidCallback onNotificationPressed;

  const CharacteristicTile(
      {Key key,
      this.characteristic,
      this.descriptorTiles,
      this.onReadPressed,
      this.onWritePressed,
      this.onNotificationPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: characteristic.value,
      initialData: characteristic.lastValue,
      builder: (c, snapshot) {
        final value = snapshot.data;
        return ExpansionTile(
          title: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Characteristic'),
                Text(
                    '0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
                    style: Theme.of(context).textTheme.body1?.copyWith(
                        color: Theme.of(context).textTheme.caption?.color))
              ],
            ),
            subtitle: Text(value.toString()),
            contentPadding: EdgeInsets.all(0.0),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.file_download,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
                ),
                onPressed: onReadPressed,
              ),
              IconButton(
                icon: Icon(Icons.file_upload,
                    color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
                onPressed: onWritePressed,
              ),
              IconButton(
                icon: Icon(
                    characteristic.isNotifying
                        ? Icons.sync_disabled
                        : Icons.sync,
                    color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
                onPressed: onNotificationPressed,
              )
            ],
          ),
          children: descriptorTiles,
        );
      },
    );
  }
}

class DescriptorTile extends StatelessWidget {
  final BluetoothDescriptor descriptor;
  final VoidCallback onReadPressed;
  final VoidCallback onWritePressed;

  const DescriptorTile(
      {Key key, this.descriptor, this.onReadPressed, this.onWritePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Descriptor'),
          Text('0x${descriptor.uuid.toString().toUpperCase().substring(4, 8)}',
              style: Theme.of(context)
                  .textTheme
                  .body1
                  ?.copyWith(color: Theme.of(context).textTheme.caption?.color))
        ],
      ),
      subtitle: StreamBuilder<List<int>>(
        stream: descriptor.value,
        initialData: descriptor.lastValue,
        builder: (c, snapshot) => Text(snapshot.data.toString()),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.file_download,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
            ),
            onPressed: onReadPressed,
          ),
          IconButton(
            icon: Icon(
              Icons.file_upload,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
            ),
            onPressed: onWritePressed,
          )
        ],
      ),
    );
  }
}

class AdapterStateTile extends StatelessWidget {
  const AdapterStateTile({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: ListTile(
        title: Text(
          'Bluetooth adapter is ${state.toString().substring(15)}',
          style: Theme.of(context).primaryTextTheme.subhead,
        ),
        trailing: Icon(
          Icons.error,
          color: Theme.of(context).primaryTextTheme.subhead?.color,
        ),
      ),
    );
  }
}

void randomDataBPM() {
  FlutterLocalNotificationsPlugin localNotification;
  var androidInitialize =
      new AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
      InitializationSettings(android: androidInitialize);
  localNotification = new FlutterLocalNotificationsPlugin();
  localNotification.initialize(initializationSettings);
  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails("channelId",
        "Local Notification", "Descri????o da notifica????o: IMC notification",
        importance: Importance.high);

    var genralNotificationDetails =
        new NotificationDetails(android: androidDetails);

    await localNotification.show(
        0,
        "??? Cuidado: Cuidado: Valor de Bpm acelerado! ???",
        "Os teus batimentos card??acos atingiram um valor superior ao recomendado, certifica-te que n??o foi um erro e fica atento!",
        genralNotificationDetails);
  }

  Random random = new Random();
//int randomNumber = random.nextInt(220); // from 0 upto 99 included

//int randomNumber = random.nextInt(170) + 50; // from 10 upto 99 included

  CollectionReference imcs =
      FirebaseFirestore.instance.collection('BatimentosCardiacos');

  for (int i = 0; i < 7; i++) {
    int randomNumber = random.nextInt(170) + 50;
    if (randomNumber > 180) _showNotification();
    imcs.add({
      'uid': auth.currentUser.uid,
      'valor': randomNumber,
      "time": Timestamp.now(),
      // "time": FieldValue.serverTimestamp(),
      // "time": firebase.firestore.FieldValue.serverTimestamp(),,
    });
  }

  print("ADICONAOS 7 NUMEROS POR BLUETOOTH TO BPM DATA");
}
