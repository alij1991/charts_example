
import 'dart:convert';

import 'package:charts_example/httpRequests/httpMethods.dart';
import 'package:charts_example/widgets/customSnackBarMessage.dart';
import 'package:charts_example/widgets/waitingCicularIndicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;

import '../utils/constants.dart';
class UserCharts extends StatelessWidget {
  final List<LineChartBarData> graphData;
  final String username;
  final List<double>dataMargins;
  final String graphTitle;
  final Function onDelete;
  const UserCharts({
    Key? key, required this.graphData, required this.dataMargins, required this.graphTitle, required this.username, required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Theme.of(context).primaryColorDark
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
                color: Colors.white,
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
              padding: const EdgeInsets.fromLTRB(8.0,0,12,0),
              child: LineChart(
                sampleData(),
                // isShowingMainData ? sampleData1() : sampleData2(),
                swapAnimationDuration: const Duration(milliseconds: 250),
                swapAnimationCurve: Curves.easeInCubic,
              ),
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8,0,8,8),
            child: Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Theme.of(context).primaryColorLight,
                child: GestureDetector(
                  onTap: () async {
                    WaitingCircularIndicator().showCircularDialog();
                    var response = await HttpMethods.delete(username: username,
                        graph_name: graphTitle
                    );
                    Navigator.pop(context);
                    if (response != 'failed') {
                      if (response['result'] == 'True') {
                         CustomSnackBarMessage().showMessage(
                            message: 'Successfully Done',
                            messageColor: kSuccessColor);
                        onDelete();

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
                  child: Icon(Icons.remove,color: Colors.white,),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  LineChartData sampleData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
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
              color: Colors.white, fontSize: 12),
          margin: 4,
        ),
        rightTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context,value) => TextStyle(
              color: Colors.white, fontSize: 10),
          margin: 4,
        ),
        topTitles: SideTitles(showTitles: false),
      ),
      gridData: FlGridData(
          show: false,
          drawVerticalLine: false,
          drawHorizontalLine: false
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
            color: Colors.white,
            width: 3,
          ),
          left: BorderSide(
            color: Colors.white,
            width: 3,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }


}
