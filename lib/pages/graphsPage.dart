import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:charts_example/httpRequests/httpMethods.dart';
import 'package:charts_example/widgets/customAppBar.dart';
import 'package:charts_example/widgets/customSnackBarMessage.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../charts/mainPageCharts.dart';
import '../charts/userCharts.dart';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../widgets/waitingCicularIndicator.dart';

class GraphsPage extends StatefulWidget {
  GraphsPage({Key? key, required this.username, this.allCharts, this.userCharts}) : super(key: key);

  final String username;
  var allCharts;
  var userCharts;

  @override
  State<GraphsPage> createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage>  with SingleTickerProviderStateMixin{

  int _currentIndex = 1;
  String _currentTitle = 'Dashboard';
  List<Widget> _chartChildren = [];
  late TabController _tabController;
  late Function pages;
  List<Stream> datasStream =[];
  List<StreamSubscription> dataStreamSubscription = [];
  List<List<FlSpot>> dataPoints = [];

  Stream<List<double>> timedCounter({required Duration interval,required String chartName,required int index,required List<double> data}) async* {
    double xVal = 0;
    double step =1;
    while (true) {
      await Future.delayed(interval);
      yield [index.toDouble(),xVal,data[index]];
      index++;
      xVal+=step;
      if(index==data.length)
        index=0;
    }
  }
  void startStreams({required HashMap data}) {
    if (dataStreamSubscription.length == 0) {
      for (int i = 0; i < data.length; i++) {
        dataPoints.add([]);
        datasStream.add(
            timedCounter(
                index: 0,
                chartName: widget.userCharts.keys.elementAt(i),
                data: widget.userCharts[widget.userCharts.keys.elementAt(i)],
                interval: Duration(milliseconds: 10)
            )
        );
        dataStreamSubscription.add(datasStream[i].listen((event) {
          while (dataPoints[i].length > data[data.keys.elementAt(0)].length-1) {
            dataPoints[i]=[];
          }
          if(mounted) {
            setState(() {
              dataPoints[i].add(FlSpot(event[0], event[2]));
            });
          }
          if (_currentIndex != 0) {
            print('Cancel Stream');
            dataStreamSubscription[i].cancel();
          }
        })
        );
      }
    }
    else {
      try {
        for (int i = 0; i < dataStreamSubscription.length; i++) {
          dataStreamSubscription[i].cancel();
        }
      }
      catch (e){
      }
      datasStream = [];
      dataStreamSubscription = [];
      dataPoints = [];
      startStreams(data: data);
    }
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('start graph');
    _tabController = TabController(vsync: this, length: 2,initialIndex: 1);

    pages = ({required allCharts,required userCharts,required String username}){
      return [
        ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: userCharts.length,
          itemBuilder: (BuildContext context, int index) {
            String chartTitle = userCharts.keys.elementAt(index);
            double minX = 0;
            double maxX = userCharts[chartTitle].length.toDouble();
            String x = '';
            List<double> result = [];
            List<FlSpot> spots =  [];
            for(int i = 0; i < maxX; i++)
            {
              result.add(userCharts[chartTitle][i].toDouble());
              spots.add(FlSpot(i.toDouble(), result[i]));
            }
            double minY = result.reduce((curr, next) => curr < next? curr: next);
            double maxY = result.reduce((curr, next) => curr > next? curr: next);

            LineChartBarData lineChartBarData = LineChartBarData(
              spots: dataPoints[index],
              isCurved: false,
              isStrokeCapRound: false,

              barWidth: 2,
              belowBarData: BarAreaData(
                show: false,
              ),
              colors: [
                Theme.of(context).primaryColorDark,
              ],
              dotData: FlDotData(show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(radius: 1,
                        color: Theme.of(context).primaryColorLight.withOpacity(1),
                        // strokeColor: Colors.white.withOpacity(1),
                        strokeWidth: 0),
              ),

              show: true,
              // showingIndicators: [-1,0,1],

            );
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: UserCharts(
                graphTitle: chartTitle,
                dataMargins: [minX,maxX,minY,max(maxY,1)],
                graphData: [lineChartBarData],
                username: username,
                onDelete: (){
                  _currentIndex = 1;
                  _tabController.animateTo(1);
                  _currentTitle = 'Dashboard';
                  setState(() {

                  });
                },
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>  SizedBox(height: 40,),
        ),

        ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: allCharts.length,
          itemBuilder: (BuildContext context, int index) {
            String chartTitle = allCharts.keys.elementAt(index);
            double minX = 0;
            double maxX = allCharts[chartTitle].length.toDouble();
            String x = '';
            List<double> result = [];
            List<FlSpot> spots =  [];
            for(int i = 0; i < maxX; i++)
            {
              result.add(allCharts[chartTitle][i]);
              spots.add(FlSpot(i.toDouble(), result[i]));
            }
            double minY = result.reduce((curr, next) => curr < next? curr: next);
            double maxY = result.reduce((curr, next) => curr > next? curr: next);

            LineChartBarData lineChartBarData = LineChartBarData(
              spots: spots,
              isCurved: true,
              colors: [
                Theme.of(context).primaryColorLight,
              ],
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: false,
              ),
              show: true,
              showingIndicators: [-1,0,1],

            );
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: MainPageCharts(
                graphTitle: chartTitle,
                dataMargins: [minX,maxX,minY,max(maxY,1)],
                graphData: [lineChartBarData],
                username: username,
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>  SizedBox(height: 40,),
        )
      ];
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Graphs Page',),
      bottomNavigationBar:  BottomAppBar(
        elevation: 8,
        child: Container(

          color: Theme.of(context).primaryColorDark,
          child: TabBar(
            onTap: (int index) async {
              _currentIndex = index;
              if(index==0) {
                _currentTitle = "My Charts";
                WaitingCircularIndicator().showCircularDialog();
                var response = await HttpMethods.getUserGraph(username: widget.username,);
                Navigator.pop(context);
                if (response != 'failed') {
                  if (response['result'] == 'True') {
                    widget.userCharts = HttpMethods.createUserCharts(response['BOTSdata']);
                    startStreams(data: widget.userCharts);
                  }
                  else {
                    CustomSnackBarMessage().showMessage(
                        message: response['error'],
                        messageColor: kErrorColor);
                  }
                } else {
                  var responseString = response.body;
                  CustomSnackBarMessage().showMessage(
                      message: response.statusCode.toString(),
                      messageColor: kErrorColor);
                }
              }
              else if (index==1) {
                _currentTitle = 'Dashboard';
                WaitingCircularIndicator().showCircularDialog();
                var response = await HttpMethods.getCharts();
                Navigator.pop(context);
                if (response != 'failed') {

                  if (response['result'] == 'True') {
                    widget.allCharts = response['data'];
                  }
                }
                else {
                  CustomSnackBarMessage().showMessage(
                      message: response,
                      messageColor: kErrorColor);
                }
              }
              setState(() {

              });
            },

            indicator: BoxDecoration(color: Theme.of(context).primaryColorLight),
            tabs: <Widget>[
              Tab(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_circle_sharp,
                    color: _currentIndex==0?Theme.of(context).primaryColorDark: Theme.of(context).primaryColorLight,),
                  Text("My Charts", style: TextStyle(fontSize: 12,
                    color:_currentIndex==0?Theme.of(context).primaryColorDark: Theme.of(context).primaryColorLight,)),
                ],
              )),
              Tab(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.dashboard_sharp,
                    color: _currentIndex==1?Theme.of(context).primaryColorDark: Theme.of(context).primaryColorLight,),
                  Text("Dashboard", style: TextStyle(fontSize: 12,
                    color:_currentIndex==1?Theme.of(context).primaryColorDark: Theme.of(context).primaryColorLight,)),
                ],
              )),
            ],
            controller: _tabController,
          ),
        ),
      ),
      body: Center(
        child: Container(
            color: Theme.of(context).backgroundColor,
            child: pages(allCharts : widget.allCharts,userCharts:widget.userCharts,username:widget.username)[_currentIndex]
        ),
      ),
    );
  }
}
