import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

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
  /* FlutterLocalNotificationsPlugin localNotification;
  @override
  void initState() {
    super.initState();
    var androidInitialize =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidInitialize);
    localNotification = new FlutterLocalNotificationsPlugin();
    localNotification.initialize(initializationSettings);

    _showNotification();
  }

  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "channelId",
        "Local Notification",
        "Descrição da puta da notificação, podes escrever o que quiseres",
        importance: Importance.high);

    var genralNotificationDetails =
        new NotificationDetails(android: androidDetails);

    await localNotification.show(
        0, "Notification Tittle", "body", genralNotificationDetails);
  }
*/
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
  FlutterLocalNotificationsPlugin localNotification;
  var androidInitialize =
      new AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
      InitializationSettings(android: androidInitialize);
  localNotification = new FlutterLocalNotificationsPlugin();
  localNotification.initialize(initializationSettings);
  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails("channelId",
        "Local Notification", "Descrição da notificação: IMC notification",
        importance: Importance.high);

    var genralNotificationDetails =
        new NotificationDetails(android: androidDetails);

    await localNotification.show(
        0,
        "⚠ Cuidado: Valor de IMC elevado! ⚠",
        "O teu Indice de Massa Corporal (IMC) é superior ao recomendado. Certifica-te que não foi um erro e mantem-te atento!",
        genralNotificationDetails);
  }

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
              _showNotification();
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

                if (int.parse(_imc) > 30) _showNotification();

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
        TextButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (context_d) => AlertDialog(
              title: const Text(
                'Niveis Normais de IMC:',
                style: TextStyle(
                    color: const Color(0xFF510A32),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              content: const Text(
                'Baixo peso (IMC inferior a 18,5)\n\nPeso normal (IMC entre 18,5 e 24,9)\n\nExcesso de peso e obesidade (IMC a partir de 25)',
                style: TextStyle(
                    color: const Color(0xFF2D142C),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
          child: const Text('Valores Recomendados de IMC!',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFFEE4540),
              )),
        ),
      ],
    ),
  );
}

Widget _WheightText(BuildContext context) {
  FlutterLocalNotificationsPlugin localNotification;
  var androidInitialize =
      new AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
      InitializationSettings(android: androidInitialize);
  localNotification = new FlutterLocalNotificationsPlugin();
  localNotification.initialize(initializationSettings);
  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails("channelId",
        "Local Notification", "Descrição da notificação: IMC notification",
        importance: Importance.high);

    var genralNotificationDetails =
        new NotificationDetails(android: androidDetails);

    await localNotification.show(
        0,
        "⚠ Cuidado: Valor de Peso elevado! ⚠",
        "O teu Peso é superior ao recomendado. Certifica-te que não foi um erro e mantem-te atento!",
        genralNotificationDetails);
  }

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
            helperText: 'ex: 70',
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

                if (int.parse(_weight) > 120) _showNotification();

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
        TextButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (context_d) => AlertDialog(
              title: const Text(
                'Niveis Normais de Peso:',
                style: TextStyle(
                    color: const Color(0xFF510A32),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              content: const Text(
                'O que a maioria dos médicos e nutricionistas concordam é que o peso saudável deve ser individualizado para cada pessoa, de acordo com o sexo, idade, altura, biotipo e existência ou não de doenças associadas.',
                style: TextStyle(
                    color: const Color(0xFF2D142C),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
          child: const Text('Valores Recomendados de peso!',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFFEE4540),
              )),
        ),
      ],
    ),
  );
}

Widget _TensaoText(BuildContext _context) {
  FlutterLocalNotificationsPlugin localNotification;
  var androidInitialize =
      new AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
      InitializationSettings(android: androidInitialize);
  localNotification = new FlutterLocalNotificationsPlugin();
  localNotification.initialize(initializationSettings);
  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails("channelId",
        "Local Notification", "Descrição da notificação: IMC notification",
        importance: Importance.high);

    var genralNotificationDetails =
        new NotificationDetails(android: androidDetails);

    await localNotification.show(
        0,
        "⚠ Cuidado: Medição de tensão elevado! ⚠",
        "O tua medição de tensão arterial é superior ao recomendado. Certifica-te que não foi um erro e mantem-te atento!",
        genralNotificationDetails);
  }

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
          cursorColor: Theme.of(_context).cursorColor,
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
                int.parse(value) >= 200) {
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

                if (int.parse(_tensao) > 140) _showNotification();

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
                  ScaffoldMessenger.of(_context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              }
            },
            child: Text('Submit'),
          ),
        ),
        TextButton(
          onPressed: () => showDialog<String>(
            context: _context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text(
                'Niveis Normais de Tensão:',
                style: TextStyle(
                    color: const Color(0xFF510A32),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              content: const Text(
                "PRESSÃO ARTERIAL NORMAL – pressão sistólica menor que 120 mmHg e pressão diastólica menor que 80 mmHg\nPRÉ-HIPERTENSÃO – pressão sistólica entre 120 e 129 mmHg ou pressão diastólica menor que 80 mmHg\nHIPERTENSÃO ESTÁGIO 1 – pressão sistólica entre 130 e 139 mmHg ou pressão diastólica entre 80 e 89 mmHg.\nHIPERTENSÃO ESTÁGIO 2 – pressão sistólica acima de 140 mmHg ou pressão diastólica acima de 90 mmHg.\nCRISE HIPERTENSIVA – pressão sistólica acima de 180 mmHg ou pressão diastólica acima de 110 mmHg.",
                style: TextStyle(
                    color: const Color(0xFF2D142C),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(_context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
          child: const Text('Valores Recomendados de Tensão!',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFFEE4540),
              )),
        ),
      ],
    ),
  );
}

Widget _BpmText(BuildContext context) {
  FlutterLocalNotificationsPlugin localNotification;
  var androidInitialize =
      new AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
      InitializationSettings(android: androidInitialize);
  localNotification = new FlutterLocalNotificationsPlugin();
  localNotification.initialize(initializationSettings);
  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails("channelId",
        "Local Notification", "Descrição da notificação: IMC notification",
        importance: Importance.high);

    var genralNotificationDetails =
        new NotificationDetails(android: androidDetails);

    await localNotification.show(
        0,
        "⚠ Cuidado: Cuidado: Valor de Bpm acelerado! ⚠",
        "Os teus batimentos cardíacos atingiram um valor superior ao recomendado, certifica-te que não foi um erro e fica atento!",
        genralNotificationDetails);
  }

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

                if (int.parse(_bpm) > 180) _showNotification();

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
        TextButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext _context) => AlertDialog(
              title: const Text(
                'Niveis Normais de Batimentos Cardiacos:',
                style: TextStyle(
                    color: const Color(0xFF510A32),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              content: const Text(
                "De 0 a 2 anos  – entre 120 e 140 bpm;\n\nEntre 8 e 17 anos – entre 80 e 100 bpm;\n\nAdulto sedentário – entre 70 e 80 bpm;\n\nAdultos praticantes de atividades físicas e idosos – entre 50 a 60 bpm.",
                style: TextStyle(
                    color: const Color(0xFF2D142C),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(_context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
          child: const Text('Valores Recomendados de BPM!',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFFEE4540),
              )),
        ),
      ],
    ),
  );
}

// ############################################################## Alert Dialogs ##################################################################################################

class BPM_DialogWidget extends StatelessWidget {
  const BPM_DialogWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Niveis Normais de batimentos cardiacos:'),
          content: const Text('AlertDialog description'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: const Text('Show Dialog'),
    );
  }
}
