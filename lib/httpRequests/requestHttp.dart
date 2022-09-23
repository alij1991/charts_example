import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestHttp{

  static Future<dynamic> getRequest(String url) async{
    var headers = {
      'Authorization': 'Bearer<1a49fec40dc6387101622b82879ad5b6>',
    };
    http.Response response = await http.get(Uri.parse(url),headers: headers,);
    try{
      if(response.statusCode == 200){
        String data = response.body;
        var decodeData = jsonDecode(data);
        return decodeData;
      }
      else{
        print('getRequest ${response.body}');
        return 'failed';
      }
    }
    catch(e){
      return 'failed';
    }
  }

  static Future<dynamic> postRequest({required String url, required var headers, var body}) async{
    late http.Response response;
    if(body==null) {
      response = await http.post(
        Uri.parse(url), headers: headers,);
    }else{
      response = await http.post(
        Uri.parse(url), headers: headers,body: body);
    }
    try{
      if(response.statusCode == 200){
        String data = response.body;
        var decodeData = jsonDecode(data);
        return decodeData;
      }
      else{
        print('getRequest ${response.body}');
        return 'failed';
      }
    }
    catch(e){
      return 'failed';
    }
  }
}