import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xiaomi_scale/xiaomi_scale.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/gestures.dart';

final auth = FirebaseAuth.instance;

class Exercice extends StatefulWidget {
  @override
  _ExerciceState createState() => _ExerciceState();
}

class _ExerciceState extends State<Exercice> {
/**
 *   MiScale _mi = MiScale.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  static List<double> _bpmList = [];
  Future<Null> bpm = FirebaseFirestore.instance
      .collection('BatimentosCardiacos')
      .where('uid', isEqualTo: auth.currentUser.uid)
      .get()
      .then((querySnapshot) {
    //clear list
    _bpmList.clear();
    querySnapshot.docs.forEach((result) {
      // print(result.data());

      int aux = result.data().values.skip(1).first;
      print(aux);

      if (aux >= 20) _bpmList.add(aux.toDouble());
      print("LIST:");
      print(_bpmList);
    });
  });
 */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Health App: Exercice'),
          backgroundColor: Colors.lightBlue.shade600,
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            LineChartSample2(),
            BarChartSample1(),
            Container(),
          ],
        )));
  }
}

class LineChartSample2 extends StatefulWidget {
  @override
  _LineChartSample2State createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    const Color(0xffff0011),
    const Color(0xfffc2c2c),
  ];

  bool showAvg = false;

  @override
  static List<double> _bpmList = [];
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                color: Color(0xff232d37)),
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 18.0, left: 12.0, top: 24, bottom: 12),
              child: LineChart(
                showAvg ? avgData() : mainData(),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 100,
          height: 50,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'BPM (dia)',
              style: TextStyle(
                  fontSize: 12,
                  color:
                      showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 0,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return '';
              case 5:
                return '';
              case 8:
                return '';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '';
              case 3:
                return '';
              case 5:
                return '';
            }
            return '';
          },
          reservedSize: 0,
          margin: 5,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 50,
      minY: 0,
      maxY: 400,
      lineBarsData: [lineChartBarData()],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return '';
              case 5:
                return '';
              case 8:
                return '';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 100,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 300,
      minY: 0,
      maxY: 500,
      lineBarsData: [lineChartBarData()],
    );
  }

  LineChartBarData lineChartBarData() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Future<Null> bpm = FirebaseFirestore.instance
        .collection('BatimentosCardiacos')
        .where('uid', isEqualTo: auth.currentUser.uid)
        .get()
        .then((querySnapshot) {
      //clear list
      _bpmList.clear();
      querySnapshot.docs.forEach((result) {
        // print(result.data());

        int aux = result.data().values.skip(1).first;
        print(aux);

        if (aux >= 20) _bpmList.add(aux.toDouble());
        print("LIST:");
        print(_bpmList);
      });
    });

    List<FlSpot> spot = [];
    for (var i = 0; i < _bpmList.length; i++) {
      var x = i + 1;
      spot.add(FlSpot(x.toDouble(), _bpmList[i]));
    }
    print(spot);
    return LineChartBarData(
      spots: spot,
      isCurved: false,
      colors: gradientColors,
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: true,
        colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
      ),
    );
  }
}

//===========================||=======================================

class BarChartSample1 extends StatefulWidget {
  final List<Color> availableColors = [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Color barBackgroundColor = const Color(0xff37434d);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  static List<double> _bpmList = [];
  static List<double> seg = [],
      ter = [],
      qua = [],
      qui = [],
      sex = [],
      sab = [],
      dom = [];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: const Color(0xff232d37),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    'BPM',
                    style: TextStyle(
                        color: const Color(0xff0f4a3c),
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Grafico estatistico média diária semanal',
                    style: TextStyle(
                        color: const Color(0xff379982),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 38,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BarChart(
                        isPlaying ? randomData() : mainBarData(),
                        swapAnimationDuration: animDuration,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: const Color(0xff0f4a3c),
                  ),
                  onPressed: () {
                    setState(() {
                      isPlaying = !isPlaying;
                      if (isPlaying) {
                        refreshState();
                      }
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.red,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.yellow] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 20,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        CollectionReference col =
            FirebaseFirestore.instance.collection("mycollection");

//Query nameQuery = col.where('nome', isEqualTo: 'Tyg');
//Query nameValorQuery = nameQuery.where('valor', isLessThan: '39');

        // var beginningDate = Date.now() - 604800000;
        //var beginningDateObject = new Date(beginningDate);

        var d = DateTime.now();
        var weekDay = d.weekday;
        var firstDayOfWeek = d.subtract(Duration(days: weekDay - 1));

        Timestamp timestamp = Timestamp.fromDate(firstDayOfWeek); //To TimeStamp

        Query bpm_uid = FirebaseFirestore.instance
            .collection('BatimentosCardiacos')
            .where('uid', isEqualTo: auth.currentUser.uid);

        Query bpm_time = FirebaseFirestore.instance
            .collection('BatimentosCardiacos')
            .where("time", isGreaterThanOrEqualTo: timestamp);

        Future<Null> _weekbpm = bpm_time.get().then((querySnapshot) {
          seg.clear(); //clear list
          ter.clear();
          qua.clear();
          qui.clear();
          sex.clear();
          sab.clear();
          dom.clear();
          querySnapshot.docs.forEach((result) {
            // print(result.data());

            int aux = result.data().values.skip(1).first; //valor
            Timestamp timestamp = result.data().values.skip(2).first;

            if (timestamp.toDate().weekday == 1) seg.add(aux.toDouble());
            if (timestamp.toDate().weekday == 2) ter.add(aux.toDouble());
            if (timestamp.toDate().weekday == 3) qua.add(aux.toDouble());
            if (timestamp.toDate().weekday == 4) qui.add(aux.toDouble());
            if (timestamp.toDate().weekday == 5) sex.add(aux.toDouble());
            if (timestamp.toDate().weekday == 6) sab.add(aux.toDouble());
            if (timestamp.toDate().weekday == 7) dom.add(aux.toDouble());

            //if(timestamp.toDate().day==)

            /***Debug***/
            print(aux);
            print(timestamp.toDate().day);
            print(timestamp.toDate().weekday);

            //  if (aux >= 20) _bpmList.add(aux.toDouble());
            //   print("LIST POR DIA DA SEMANA:");
            // print(_bpmList);
          });
        });

        // Query _weekbmp = bpm..where('valor', isLessThan: '39');
        double average(List<double> list) {
          double sum = 0.0;
          for (int i = 0; i < list.length; i++) sum += list.elementAt(i);
          return sum / list.length;
        }

        switch (i) {
          case 0:
            return makeGroupData(0, seg.length > 0 ? average(seg) : 0.0,
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, ter.length > 0 ? average(ter) : 0.0,
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, qua.length > 0 ? average(qua) : 0.0,
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, qui.length > 0 ? average(qui) : 0.0,
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, sex.length > 0 ? average(sex) : 0.0,
                isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, sab.length > 0 ? average(sab) : 0.0,
                isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, dom.length > 0 ? average(dom) : 0.0,
                isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    //dados reais a utilizar

    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                weekDay + '\n',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.y - 1).toString(),
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! PointerUpEvent &&
                barTouchResponse.touchInput is! PointerExitEvent) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 1:
            return makeGroupData(1, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 2:
            return makeGroupData(2, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 3:
            return makeGroupData(3, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 4:
            return makeGroupData(4, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 5:
            return makeGroupData(5, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 6:
            return makeGroupData(6, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          default:
            return throw Error();
        }
      }),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      await refreshState();
    }
  }
}
