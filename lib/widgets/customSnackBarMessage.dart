import 'package:charts_example/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomSnackBarMessage{
  CustomSnackBarMessage();
  void showMessage({required String message, required Color messageColor}){
    ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
        SnackBar(
            backgroundColor:messageColor,
            duration: Duration(seconds: 2),
            content: Container(
              height: 40,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(message,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            )
        )
    );
  }
}