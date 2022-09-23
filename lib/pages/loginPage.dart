import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:charts_example/httpRequests/httpMethods.dart';
import 'package:charts_example/pages/graphsPage.dart';
import 'package:charts_example/pages/signupPage.dart';
import 'package:charts_example/widgets/customAppBar.dart';
import 'package:charts_example/widgets/customSnackBarMessage.dart';
import 'package:charts_example/widgets/waitingCicularIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

import '../utils/checkUserPassValidity.dart';
import '../utils/constants.dart';
import '../widgets/customHeroIcon.dart';
import '../widgets/customTextField.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username = "";
  String _password = "";
  late var allCharts;
  WaitingCircularIndicator waitingCircularIndicator = WaitingCircularIndicator();
  CustomSnackBarMessage customSnackBarMessage = CustomSnackBarMessage();

  void loginButtonPressed() async{
    if(!CheckUserPassValidity.checkUserPasswordValidity(username: _username, password: _password)) {
      customSnackBarMessage.showMessage(
          message:'Username or password is empty!',
          messageColor: kErrorColor);
    }
    else {
      FocusScope.of(context).unfocus();
      waitingCircularIndicator.showCircularDialog();
      try {
        var data = await HttpMethods.login(username: _username,
            password: _password
        );
        Navigator.pop(context);
        if (data != 'failed') {
          if (data['result'] == 'True') {
            var userCharts = HttpMethods.createUserCharts(data['BOTSdata']);
            var response = await HttpMethods.getCharts();

            if (response !='failed') {

              if (response['result'] == 'True') {
                allCharts = response['data'];
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: GraphsPage(username: _username,
                      allCharts: allCharts,
                      userCharts: userCharts,),
                  ),
                );
              }
            }
            else {
              customSnackBarMessage.showMessage(
                  message: data['error'],
                  messageColor: kErrorColor);
            }
          }
          else {
            customSnackBarMessage.showMessage(
                message: data['error'],
                messageColor: kErrorColor);
          }
        } else {
          customSnackBarMessage.showMessage(
              message: data,
              messageColor: kErrorColor);
        }
      }
      catch(e){
        Navigator.pop(context);
        customSnackBarMessage.showMessage(
            message: 'Connection problem',
            messageColor: kErrorColor);
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Login Page',noBackButton: true),
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              CustomHeroIcon(),
              SizedBox(
                height: 50,
              ),
              LoginInput(hint_txt: 'Username',obscure_txt: false,
                onTextChanged: (value)=>_username=value,
              ),
              SizedBox(
                height: 10,
              ),
              LoginInput(hint_txt: 'Password',obscure_txt: true,
                onTextChanged: (value)=>_password=value,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 8),
                child: GestureDetector(
                  onTap: loginButtonPressed,
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.circular(8.0),
                      // border: Border.all(width: 2.0, color: Theme.of(context).primaryColorLight),
                      gradient: LinearGradient(
                          colors: [Theme.of(context).primaryColorDark, Theme.of(context).primaryColorLight]),
                    ),
                    child: Center(
                      child: Text(
                        'Log in',
                        style: TextStyle(fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dont have an account? ',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeftWithFade,
                          child: SignupPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
