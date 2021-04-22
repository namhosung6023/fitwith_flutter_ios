import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fitwith/config/env.dart';

Dio dio;
BaseOptions options = dioOptions;

Response response;
Map<String, dynamic> data = {'success': '', 'message': ''};


Future<Map<String, dynamic>> postJoin(Map<String, String> user) async {
  if (dio == null) dio = Dio(options);

  try {
    response = await dio.post('accounts/join', data: jsonEncode(user));
    return response.data;
  } on DioError catch (e) {
    data['success'] = false;
    data['message'] = e.message;
    return data;
  }
}

Future<Map<String, dynamic>> postLogin(Map<String, String> user) async {
  if (dio == null) dio = Dio(options);

  try {
    response = await dio.post('accounts/login', data: jsonEncode(user));
    return response.data;
  } on DioError catch (e) {
    data['success'] = false;
    data['message'] = e.message;
    return data;
  }
}

Future<Map<String, dynamic>> getUser(String token) async {
  if (dio == null) dio = Dio(options);
  dio.options.headers["accesstoken"] = token;

  try {
    response = await dio.get('accounts/profile');
    return response.data['data'];
  } on DioError catch (e) {
    data['success'] = false;
    data['message'] = e.message;
    return data;
  }
}
