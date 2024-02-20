import 'package:http/http.dart' as http;
// import 'package:primera_app/controls/utils/Utiles.dart';

import 'dart:convert';
import 'dart:async';
import 'package:primera_app/models/Response.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String URL = 'http://localhost:3000/';

Future<Response> obtener(String recurso, bool token) async {
  Map<String, String> _header = {};
  Map<String, dynamic> _response = {};

  // if (token) {
  //   Utiles util = Utiles();
  //   String? tokenA = await util.getValue('token');
  //   _header = {'token': tokenA.toString()};
  //   print(_header);
  // }

  if (token) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenA = prefs.getString('token');
    _header = {'Authorization': tokenA ?? ''};
  }

  final String _url = URL + recurso;
  final uri = Uri.parse(_url);

  final response = await http.get(uri, headers: _header);

  _response = jsonDecode(response.body) as Map<String, dynamic>;
  _response['code'] = response.statusCode;

  return Response.fromJson(_response as Map<String, dynamic>);
}

Future<Response> enviar(String recurso, bool token, dynamic cuerpo, bool format) async {
  Map<String, String> _header = {
    'Content-Type': 'application/json; charset=UTF-8'
  };
  Map<String, dynamic> _response = {};

  // if (token) {
  //   Utiles util = Utiles();
  //   String? tokenA = await util.getValue('token');
  //   _header = {'token': tokenA.toString()};
  // }

  if (token) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenA = prefs.getString('token');
    _header = {'Authorization': tokenA ?? ''};
  }

  final String _url = URL + recurso;
  final uri = Uri.parse(_url);

  final response;

  if(format){
    response = await http.post(uri, headers: _header, body: jsonEncode(cuerpo));
  }else{
    response = await http.post(uri, headers: _header, body: cuerpo);
  }

  _response = jsonDecode(response.body) as Map<String, dynamic>;
  _response['code'] = response.statusCode;

  return Response.fromJson(_response as Map<String, dynamic>);
}
