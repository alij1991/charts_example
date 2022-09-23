import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'requestHttp.dart';

class HttpMethods{

  static HashMap createUserCharts(var data)
  {
    HashMap<String, List<double>> result = HashMap<String, List<double>>();
    if (data.toString().length>0) {
      var tempdata = jsonDecode(
          data.toString().replaceAll("[", "").replaceAll("]", ""));

      for (int j = 0; j < tempdata.length; j++) {
        List<double> templist = [];
        String chartTitle = tempdata.keys.elementAt(j);
        var check = tempdata[chartTitle].toString().split(",");
        for (int i = 0; i < check.length; i++) {
          templist.add(double.parse(check[i]));
        }
        result[chartTitle] = templist;
      }
    }
    return result;
  }

  static Future<dynamic> getCharts()async{
    return RequestHttp.getRequest('https://djangoapp.alijavdani.ir/bots/',);
  }

  static Future<dynamic> login({username,password})async {
    var headers = {
      'UserID': username.toString(),
      'Password': password.toString(),
      'Authorization': 'Bearer<1a49fec40dc6387101622b82879ad5b6>',
      'Cache-Control':'no-cache'
    };
    try {
      return RequestHttp.postRequest(url: 'https://djangoapp.alijavdani.ir/login/',headers: headers).
      timeout(Duration(seconds: 5));
    } on TimeoutException catch (e) {
      throw Error();
    } on SocketException catch (e) {
      throw Error();
    } on Error catch (e) {
      throw Error();
    }
  }

  static Future<dynamic> signup({username,password})async{
    var headers = {
      'Authorization': 'Bearer<1a49fec40dc6387101622b82879ad5b6>',
      'Content-Type':'application/json'
    };
    var body = {
      'UserID': username.toString(),
      'Password': password.toString(),
    };

    try {
      return RequestHttp.postRequest(url: 'https://djangoapp.alijavdani.ir/signup/',headers: headers,body: jsonEncode(body)).
      timeout(Duration(seconds: 5));
    } on TimeoutException catch (e) {
      throw Error();
    } on SocketException catch (e) {
      throw Error();
    } on Error catch (e) {
      throw Error();
    }
  }

  static Future<dynamic> getUserGraph({required String username})async{
    var headers = {
      'Authorization': 'Bearer<1a49fec40dc6387101622b82879ad5b6>',
      'UserID': username,
    };
    var body = {

    };
    return RequestHttp.postRequest(url: 'https://djangoapp.alijavdani.ir/userbots/',headers: headers,body:jsonEncode(body));
  }

  static Future<dynamic> addGraph({username,graph_name})async{
    var headers = {
      'Authorization': 'Bearer<1a49fec40dc6387101622b82879ad5b6>',
    };
    var body = {
      'UserID': username,
      'BOTSID': graph_name
    };
    return RequestHttp.postRequest(url: 'https://djangoapp.alijavdani.ir/add/',headers: headers,body:jsonEncode(body));
  }

  static Future<dynamic> delete({username,graph_name})async{
    var headers = {
      'Authorization': 'Bearer<1a49fec40dc6387101622b82879ad5b6>',
    };
    var body = {
      'UserID': username,
      'BOTSID': graph_name
    };
    return RequestHttp.postRequest(url: 'https://djangoapp.alijavdani.ir/delete/',headers: headers,body:jsonEncode(body));
  }

}