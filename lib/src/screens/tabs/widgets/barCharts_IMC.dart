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

import 'package:flutter/material.dart';

final auth = FirebaseAuth.instance;

class BarChartIMC extends StatefulWidget {
  final List<Color> availableColors = [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];
  @override
  State<StatefulWidget> createState() => BarChartIMCState();
}

class BarChartIMCState extends State<BarChartIMC>
    with AutomaticKeepAliveClientMixin<BarChartIMC> {
  final Color barBackgroundColor = const Color(0xff37434d);
  final Duration animDuration = const Duration(milliseconds: 250);
  bool get wantKeepAlive => true;
  int touchedIndex = -1;

  bool isPlaying = false;

  static const laranja = 0xFFEE4540;
  static const vermelho_claro = 0xFFC72C41;
  static const vermelho_escuro = 0xFF801336;
  static const purpura = 0xFF510A32;
  static const roxo = 0xFF2D142C;

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
                    'IMC',
                    style: TextStyle(
                        color: const Color(vermelho_escuro),
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Grafico estatistico média diária semanal',
                    style: TextStyle(
                        color: const Color(0xFFC72C41),
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
                    color: const Color(vermelho_escuro),
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
    Color barColor = const Color(0xffffbf00),
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
            .collection('IMC')
            .where('uid', isEqualTo: auth.currentUser.uid);

        Query bpm_time = FirebaseFirestore.instance
            .collection('IMC')
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
