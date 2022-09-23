
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DialogDetailsCharts extends StatefulWidget {
  final double barWidth;
  final List<BarChartGroupData> graphData;
  final List<double>dataMargins;
  const DialogDetailsCharts({Key? key, required this.barWidth, required this.graphData, required this.dataMargins}) : super(key: key);
  @override
  State<StatefulWidget> createState() => DialogDetailsChartsState();
}

class DialogDetailsChartsState extends State<DialogDetailsCharts> {

  int touchedIndex = -1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: BarChart(
        BarChartData(
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Theme.of(context).primaryColorLight,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    String month;
                    switch (group.x.toInt()) {
                      case 0:
                        month = 'Jan';
                        break;
                      case 1:
                        month = 'Feb';
                        break;
                      case 2:
                        month = 'Mar';
                        break;
                      case 3:
                        month = 'Apr';
                        break;
                      case 4:
                        month = 'Jun';
                        break;
                      case 5:
                        month = 'Jul';
                        break;
                      default:
                        throw Error();
                    }
                    return BarTooltipItem(
                      month + '\n',
                      TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: (rod.y).toString(),
                          style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
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
                    touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                  } else {
                    touchedIndex = -1;
                  }
                });
              },
            ),
          alignment: BarChartAlignment.center,
          maxY: widget.dataMargins[3],
          minY: widget.dataMargins[2],
          groupsSpace: 20,

          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => TextStyle(color: Theme.of(context).primaryColorLight, fontSize: 14,fontWeight: FontWeight.bold),
              margin: 10,
              rotateAngle: 0,
              getTitles: (double value) {
                switch (value.toInt()) {
                  case 0:
                    return 'Jan';
                  case 1:
                    return 'Feb';
                  case 2:
                    return 'Mar';
                  case 3:
                    return 'Apr';
                  case 4:
                    return 'Jun';
                  case 5:
                    return 'Jul';
                  default:
                    return '';
                }
              },
            ),

            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => TextStyle(color: Theme.of(context).primaryColorLight, fontSize: 12,fontWeight: FontWeight.bold),
              rotateAngle: 45,
              getTitles: (double value) {
                if (value == 0) {
                  return '0';
                }
                return '${value.toInt()}%';
              },
              interval: 5,
              margin: 8,
              reservedSize: 30,
            ),

          ),
          gridData: FlGridData(
            show: true,
            checkToShowHorizontalLine: (value) => value % 5 == 0,
            getDrawingHorizontalLine: (value) {
              if (value == 0) {
                return FlLine(color: Theme.of(context).primaryColorLight, strokeWidth: 3);
              }
              return FlLine(
                color: Theme.of(context).primaryColorLight,
                strokeWidth: 0.8,
              );
            },
          ),
          borderData: FlBorderData(
            show: false,
          ),

          barGroups: widget.graphData
        ),
      ),
    );
  }
}
