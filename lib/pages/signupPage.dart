import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:charts_example/httpRequests/httpMethods.dart';
import 'package:charts_example/widgets/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/checkUserPassValidity.dart';
import '../utils/constants.dart';
import '../widgets/customHeroIcon.dart';
import '../widgets/customSnackBarMessage.dart';
import '../widgets/customTextField.dart';
import '../widgets/waitingCicularIndicator.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _username = "";
  String _password = "";
  WaitingCircularIndicator waitingCircularIndicator = WaitingCircularIndicator();
  CustomSnackBarMessage customSnackBarMessage = CustomSnackBarMessage();

  void signupButtonPressed() async{
    if(!CheckUserPassValidity.checkUserPasswordValidity(username: _username, password: _password)) {
      customSnackBarMessage.showMessage(
          message:'Username or password is empty!',
          messageColor: kErrorColor);
    }
    else {
      FocusScope.of(context).unfocus();
      try {
        waitingCircularIndicator.showCircularDialog();
        var response = await HttpMethods.signup(username: _username,
            password: _password
        );
        Navigator.pop(context);
        if (response != 'failed') {
          if (response['result'] == 'True') {
            customSnackBarMessage.showMessage(
                message: 'Successfully Done',
                messageColor: kSuccessColor);
            Navigator.pop(context, true);
          }
          else {
            customSnackBarMessage.showMessage(
                message: response['error'].toString(),
                messageColor: kErrorColor);
          }
        } else {
          customSnackBarMessage.showMessage(
              message: response,
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
      appBar: CustomAppbar(title: 'Sign Up',),
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
              LoginInput(hint_txt: 'Choose a username',obscure_txt: false,
                onTextChanged: (value)=>_username=value,),
              SizedBox(
                height: 10,
              ),
              LoginInput(hint_txt: 'Choose a password',obscure_txt: true,
                onTextChanged: (value)=>_password=value,),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 8),
                child: GestureDetector(
                  onTap: signupButtonPressed,
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
                        'Sign up',
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
                height: 14,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  GestureDetector(
                    onTap: ()=>Navigator.pop(context,true),
                    child: Text(
                      'Log in',
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
