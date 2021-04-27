import 'package:dio/dio.dart';
import 'package:fitwith/config/env.dart';
import 'package:fitwith/models/model_beta.dart';
import 'package:shared_preferences/shared_preferences.dart';

Dio dio;
BaseOptions options = dioOptions;
Response response;
Map<String, dynamic> data = {'success': '', 'message': ''};

Future<List> getBetaList() async {
  if (dio == null) dio = Dio(options);
  try {
    response = await dio.get('beta/list');
    List _betaList = [];
    if (response.data['data'] != null) {
      if (response.data['data'].length > 0) {
        for (int i = 0; i < response.data['data'].length; i++) {
          print(response.data['data']);
          Beta _beta = Beta(
            response.data['data'][i]['_id'],
            response.data['data'][i]['title'],
            response.data['data'][i]['contents'],
            response.data['data'][i]['type'],
            response.data['data'][i]['user']['_id'],
            response.data['data'][i]['user']['username'],
            DateTime.parse(response.data['data'][i]['createdAt']),
            response.data['data'][i]['user']['avatar']
          );
          _betaList.add(_beta);
        }
      }
    }
    return _betaList;
  } on DioError catch (e) {
    data['success'] = false;
    data['message'] = e.message;
    return [data];
  }
}

Future<void> postBetaList(String title, String contents, String type) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String _token = prefs.getString('token');
  print('postBetaList 실행');
  if (dio == null) dio = Dio(options);
  try {
    dio.options.headers['accesstoken'] = _token;
    response = await dio.post('beta/register', data: {
      // "userId" : userId,
      "title" : title,
      "contents" : contents,
      "type" : type,
    });
  } on DioError catch (e) {
    print('postBetaList: ${e.message}');
  }
}

Future<void> deleteCommunity(String title, String contents, String type) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String _token = prefs.getString('token');
  print('postBetaList 실행');
  if (dio == null) dio = Dio(options);
  try {
    dio.options.headers['accesstoken'] = _token;
    response = await dio.post('beta/register', data: {
      // "userId" : userId,
      "title" : title,
      "contents" : contents,
      "type" : type,
    });
  } on DioError catch (e) {
    print('postBetaList: ${e.message}');
  }
}
