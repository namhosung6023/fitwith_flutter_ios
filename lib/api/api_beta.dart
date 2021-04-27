import 'package:dio/dio.dart';
import 'package:fitwith/config/env.dart';
import 'package:fitwith/models/model_beta.dart';

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
