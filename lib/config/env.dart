import 'package:dio/dio.dart';

const String BASE_URL = 'http://10.0.2.2:3000/';
// const String BASE_URL = 'http://52.79.106.30:3000/';

BaseOptions dioOptions = BaseOptions(
  baseUrl: BASE_URL,
  receiveDataWhenStatusError: true,
  connectTimeout: 10 * 1000,
  receiveTimeout: 10 * 1000,
);
