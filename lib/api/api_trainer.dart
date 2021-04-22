import 'package:dio/dio.dart';
import 'package:fitwith/config/env.dart';

Dio dio;
BaseOptions options = dioOptions;

Response response;
Map<String, dynamic> data = {'success': '', 'message': ''};

Future<Map<String, dynamic>> getTrainerList() async {
  if (dio == null) dio = Dio(options);

  try {
    response = await dio.get('trainer/list');
    return response.data;
  } on DioError catch (e) {
    data['success'] = false;
    data['message'] = e.message;
    return data;
  }
}
