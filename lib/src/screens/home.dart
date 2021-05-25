import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lpi_app/src/screens/login.dart';
import 'package:lpi_app/src/screens/tabs/addtab.dart';
import 'package:lpi_app/src/screens/tabs/dashboard.dart';
import 'package:lpi_app/src/screens/tabs/exercice.dart';
import 'package:lpi_app/src/screens/tabs/bluetooth.dart';
import 'database/userdata.dart';
import 'tabs/addtab.dart';
import 'tabs/dashboard.dart';
import 'tabs/exercice.dart';
import 'tabs/bluetooth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  bool get wantKeepAlive => true;
  final auth = FirebaseAuth.instance;
  int _currentTab = 0;
  final List<Widget> screens = [Dashboard(), Exercice(), AddTab(), Bluetooth()];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget _currentScreen = Exercice(); //tab inicial!!!!
/*
  Future<String> createAlertDialog(BuildContext context) {
    TextEditingController customController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("INSERIR Manualmente BPM <3)"),
            content: TextField(
              controller: customController,
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text('Submit'),
                onPressed: () {
                  Navigator.of(context).pop(customController.text.toString());
                },
              )
            ],
          );
        });
  }
*/

  @override
  static const laranja = 0xFFEE4540;
  static const vermelho_claro = 0xFFC72C41;
  static const vermelho_escuro = 0xFF801336;
  static const purpura = 0xFF510A32;
  static const roxo = 0xFF2D142C;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health App'),
        backgroundColor: Color(0xFF801336),
      ),
      drawer: CustomDrawer(),
      /*   Navigator bar*/

      /*   body   */
      body: PageStorage(
        child: _currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFC72C41),
        splashColor: Color(0xFFEE4540),
        child: Icon(Icons.add),
        onPressed: () async {
          // createAlertDialog(context);
          //then((onValue) {
          //SnackBar mySnackbar = SnackBar(content: Text("HEllo $onValue"));
          //Scaffold.of(context).showSnackBar(mySnackbar);
          // });
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        _currentScreen = Exercice();
                        _currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.fitness_center_outlined,
                            color: _currentTab == 0
                                ? Color(0xFFC72C41)
                                : Color(0xFF2D142C)),
                        Text("Exercicio",
                            style: TextStyle(
                                color: _currentTab == 0
                                    ? Color(0xFFC72C41)
                                    : Color(0xFF2D142C)))
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        _currentScreen = Dashboard();
                        _currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.stacked_bar_chart,
                          color: _currentTab == 1
                              ? Color(0xFFC72C41)
                              : Color(0xFF2D142C),
                        ),
                        Text("Dashboard",
                            style: TextStyle(
                                color: _currentTab == 1
                                    ? Color(0xFFC72C41)
                                    : Color(0xFF2D142C)))
                      ],
                    ),
                  ),
                  /* MaterialButton(
                minWidth: 40,
                onPressed: (){
                  setState(() {
                    _currentScreen= AddTab();
                    _currentTab=2;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      color: _currentTab==2 ? Colors.blue : Colors.blueGrey ,
                    ),
                    Text("TAB",
                    style: TextStyle(color: _currentTab==2 ? Colors.blue : Colors.blueGrey  )
                    )

                      ],
                ),
              ),
              MaterialButton(
                minWidth: 40,
                onPressed: (){
                  setState(() {
                    _currentScreen= Settings();
                    _currentTab=3;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.settings,
                      color: _currentTab==3 ? Colors.blue : Colors.blueGrey ,
                    ),
                    Text("Exercicio",
                    style: TextStyle(color: _currentTab==3 ? Colors.blue : Colors.blueGrey  )
                    )

                      ],
                ),
              ),*/
                ],
              ),
              //lado direito do notch da tab bar
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*     MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        _currentScreen= Exercice();
                        _currentTab=0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fitness_center_outlined,
                          color: _currentTab==0 ? Colors.blue : Colors.blueGrey ,
                        ),
                        Text("Exercicio",
                            style: TextStyle(color: _currentTab==0 ? Colors.blue : Colors.blueGrey  )
                        )

                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        _currentScreen= Dashboard();
                        _currentTab=1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.stacked_bar_chart,
                          color: _currentTab==1 ? Colors.blue : Colors.blueGrey ,
                        ),
                        Text("Dashboard",
                            style: TextStyle(color: _currentTab==1 ? Colors.blue : Colors.blueGrey  )
                        )

                      ],
                    ),
                  ),
*/
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        _currentScreen = AddTab();
                        _currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: _currentTab == 2
                              ? Color(0xFFC72C41)
                              : Color(0xFF2D142C),
                        ),
                        Text("Add data",
                            style: TextStyle(
                                color: _currentTab == 2
                                    ? Color(0xFFC72C41)
                                    : Color(0xFF2D142C)))
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        _currentScreen = Bluetooth();
                        _currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.settings,
                          color: _currentTab == 3
                              ? Color(0xFFC72C41)
                              : Color(0xFF2D142C),
                        ),
                        Text("Bluetooth",
                            style: TextStyle(
                                color: _currentTab == 3
                                    ? Color(0xFFC72C41)
                                    : Color(0xFF2D142C)))
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      //AddUserdata("testeemail@email.com", "this.name", 180, "adsdsadasdasdas"),
      //AddUser(auth.currentUser.uid,"Jhonny Sins",auth.currentUser.email,192),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                Color(0xFF510A32),
                Color(0xFFEE4540),
              ])),
              child: Container(
                child: Column(
                  children: [
                    Material(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        elevation: 10,
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Image.asset(
                              'images/heart_logo.png',
                              width: 80,
                              height: 80,
                            ))),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        'Health APP drawer',
                        style:
                            TextStyle(color: Color(0xFFEE4540), fontSize: 20.0),
                      ),
                    )
                  ],
                ),
              )),
          CustomListTitle(Icons.person, 'Perfil de Utilizador', () {}),
          CustomListTitle(Icons.notifications, 'Notificações', () {}),
          CustomListTitle(Icons.settings, 'Definições', () {}),
          CustomListTitle(Icons.logout, 'Log Out', () async {
            await signOut();
            await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()));
            // await Navigator.pushAndRemoveUntil(
            //  context,
            //  MaterialPageRoute(builder: (context) => LoginScreen()),
            //  (route) => false);
            //    if (auth.currentUser == null)
            //  Navigator.of(context).pushReplacement(
            //    MaterialPageRoute(builder: (context) => LoginScreen()));
          }),
        ],
      ),
    );
  }

  Future signOut() async {
    print('###Termino de sessão com sucesso no User: ' +
        auth.currentUser.email +
        '(cID:' +
        auth.currentUser.uid +
        ')###');
    try {
      return await auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

class CustomListTitle extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  CustomListTitle(this.icon, this.text, this.onTap); //construtor

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFEE4540)))),
        child: InkWell(
          splashColor: Color(0xFFC72C41),
          onTap: onTap,
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_right)
              ],
            ),
          ),
        ),
      ),
    ); //ontap
  }
}
