
import 'dart:convert';
import 'dart:math';

import 'package:charts_example/httpRequests/httpMethods.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../widgets/customSnackBarMessage.dart';
import '../widgets/waitingCicularIndicator.dart';
import 'dialogDetailsCharts.dart';


class MainPageCharts extends StatelessWidget {
  final List<LineChartBarData> graphData;
  final String username;
  final List<double>dataMargins;
  final String graphTitle;

  MainPageCharts({
    Key? key, required this.graphData, required this.dataMargins, required this.graphTitle, required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Theme.of(context).cardColor
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 4,
          ),
          Text(
            graphTitle,
            style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: 14,
                fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0,2,16,2),
              child: LineChart(
                sampleData(),
                swapAnimationDuration: const Duration(milliseconds: 250),
                swapAnimationCurve: Curves.easeInCubic,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8,0,8,8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColorDark,
                  child: GestureDetector(
                    onTap: (){
                      showDetailDialog(context: context,title: graphTitle);
                    },
                    child: Icon(Icons.search),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColorDark,
                  child: GestureDetector(
                    onTap: () async {
                      WaitingCircularIndicator().showCircularDialog();
                      var response = await HttpMethods.addGraph(username: username,
                          graph_name: graphTitle
                      );
                      Navigator.pop(context);
                      if (response != 'failed') {
                        if (response['result'] == 'True') {
                          CustomSnackBarMessage().showMessage(
                              message: 'Successfully Done',
                              messageColor: kSuccessColor);
                        }
                        else {
                          CustomSnackBarMessage().showMessage(
                              message: response['error'],
                              messageColor: kErrorColor);
                        }
                      } else {
                        CustomSnackBarMessage().showMessage(
                            message: response,
                            messageColor: kErrorColor);
                      }
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  void showDetailDialog({required BuildContext context,required String title})
  {
    double barWidth =20;
    List<int> xData = [0,1,2,3,4,5];
    final _random = Random();
    List<double> yData = [];
    for (int i=0;i<xData.length;i++) {
      yData.add(double.parse(((_random.nextDouble() * 100)-50).toStringAsFixed(2)));
    }
    double minY = yData.reduce((curr, next) => curr < next? curr: next);
    double maxY = yData.reduce((curr, next) => curr > next? curr: next);
    List <BarChartGroupData> profitData = [];
    List<double> bordersRadius = [0,0,0,0];

    for (int i =0;i<xData.length;i++)
      {
        if (yData[i]>0) {
          bordersRadius[0] = 4;
          bordersRadius[1] = 4;
          bordersRadius[2] = 0;
          bordersRadius[3] = 0;
        }
        else{
          bordersRadius[0] = 0;
          bordersRadius[1] = 0;
          bordersRadius[2] = 4;
          bordersRadius[3] = 4;
        }
        profitData.add(
          BarChartGroupData(
            x: xData[i],
            barRods: [
              BarChartRodData(
                y: yData[i],
                width: barWidth,
                colors: [yData[i]>0?Theme.of(context).colorScheme.secondary:Theme.of(context).colorScheme.secondary],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(bordersRadius[0]),
                    topRight: Radius.circular(bordersRadius[1]),
                    bottomLeft: Radius.circular(bordersRadius[2]),
                    bottomRight: Radius.circular(bordersRadius[3]),
                ),

              ),
            ],
          )
        );
      }


    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: 400,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16),bottomLeft: Radius.circular(0),bottomRight: Radius.circular(0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Random bar chart',style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0,8,16,8),
                  child: DialogDetailsCharts(graphData: profitData,dataMargins: [0,5,minY,maxY],barWidth: 20,),
                )
              ],
            ),
          );
        });
  }

  LineChartData sampleData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Theme.of(navigatorKey.currentState!.context).colorScheme.secondary.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      lineBarsData: graphData,
      minX: dataMargins[0],
      maxX: dataMargins[1],
      minY: dataMargins[2],
      maxY: dataMargins[3],
      titlesData: FlTitlesData(
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context,value) => TextStyle(
              color: Theme.of(context).colorScheme.secondary, fontSize: 12),
          margin: 4,
        ),
        rightTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => TextStyle(
              color: Theme.of(context).colorScheme.secondary, fontSize: 10),
          margin: 4,
        ),
        topTitles: SideTitles(showTitles: false),
      ),
      gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true
      ),
      borderData: FlBorderData(show: true),
    );
  }


}
