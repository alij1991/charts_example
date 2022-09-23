import 'package:charts_example/utils/constants.dart';
import 'package:flutter/material.dart';

class WaitingCircularIndicator {

  const WaitingCircularIndicator();

  void showCircularDialog(){
    showDialog(
        context: navigatorKey.currentState!.context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Center(
              child: Container(
                height: 60,
                width: 60,
                color: Colors.transparent,
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColorDark,
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColorLight),
                ),
              ),
            ),
          );
        });
  }
}
