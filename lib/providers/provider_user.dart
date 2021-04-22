   import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fitwith/config/env.dart';
import 'package:fitwith/models/model_bodylog.dart';
import 'package:fitwith/models/model_checklist.dart';
import 'package:fitwith/models/model_comment.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User extends ChangeNotifier {
  static String _premiumId;
  static DateTime _startDate;
  static DateTime _endDate;
  static String _trainerId;
  static String _myTrainerId;
  static String _token;
  static String _type; // 1 일반유저, 2 트레이너
  static String _username;
  static int _age;
  static String _gender;
  static DateTime _selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  static Comment _trainerComment;
  static String _trainerName;
  static String _trainerProfile;
  static List<CheckList> _workoutList = [];
  static List<CheckList> _dietList = [];
  static BodyLog _bodyLog;
  static bool _isScroll;

  String get premiumId => _premiumId ?? '';
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  String get trainerId => _trainerId ?? '';
  String get myTrainerId => _myTrainerId ?? '';
  String get token => _token;
  String get type => _type ?? '';
  String get username => _username ?? '';
  int get age => _age ?? 0;
  String get gender => _gender ?? '';
  DateTime get selectedDay => _selectedDay;
  Comment get trainerComment => _trainerComment;
  String get trainerName => _trainerName;
  String get trainerProfile => _trainerProfile;
  List<CheckList> get workoutList => _workoutList;
  List<CheckList> get dietList => _dietList;
  BodyLog get bodyLog => _bodyLog ?? BodyLog('', DateTime.now());
  bool get isScroll => _isScroll ?? false;

  set myTrainerId(String value) {
    _myTrainerId = value;
    notifyListeners();
  }

  set isScroll(bool value) => _isScroll = value;

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    return _token;
  }

  Dio dio;
  BaseOptions options = dioOptions;

  Future<String> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    print('token: $_token');
    if (dio == null) dio = Dio(options);

    if (_token == null) {
      print('token is null');
      return 'token is null';
    } else {
      try {
        dio.options.headers['accesstoken'] = _token;
        Response response = await dio.get('accounts/profile');

        if (response.data['data']['trainer'] != null)
          _trainerId = response.data['data']['trainer'] as String;

        if (response.data['data']['premiumTrainer'].length > 0)
          _premiumId =
              response.data['data']['premiumTrainer'][0]['premium'] as String;
        if (response.data['data']['premiumTrainer'].length > 0)
          _myTrainerId =
              response.data['data']['premiumTrainer'][0]['trainer'] as String;
        else
          _myTrainerId = '';

        _type = response.data['data']['type'] as String;
        _username = response.data['data']['username'] as String;
        _age = response.data['data']['age'] as int;
        _gender = response.data['data']['gender'] as String;

        if (_type == '1' &&
            response.data['data']['premiumTrainer'].length == 0) {
          print('프리미엄 등록 안됨!');
          return '프리미엄 서비스를 신청하지 않았습니다.';
        }
        notifyListeners();
      } on DioError catch (e) {
        return e.message;
      }
    }
  }

  Future<String> postApplyPremium(String trainerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString('token');

    if (dio == null) dio = Dio(options);

    if (_token == null) {
      print('token is null');
      return 'token is null';
    } else {
      try {
        dio.options.headers['accesstoken'] = _token;
        Response response = await dio.post('premium/apply/$trainerId');
        _premiumId = response.data['premiumId'];
        _startDate = DateTime.parse(response.data['startDate']);
        _endDate = DateTime.parse(response.data['endDate']);
        _myTrainerId = trainerId;
        notifyListeners();
        return response.data['premiumId'];
      } on DioError catch (e) {
        print(e.message);
        return e.message;
      }
    }
  }

  Future<String> getPremiumUserData({DateTime date}) async {
    print(_selectedDay);
    if (date != null) _selectedDay = DateTime(date.year, date.month, date.day);

    if (dio == null) dio = Dio(options);

    if (_token == null) {
      return 'token is null';
    } else {
      try {
        dio.options.headers['accesstoken'] = _token;
        Response response = await dio.get('premium/user/$_premiumId',
            queryParameters: {"date": _selectedDay});

        if (response.data['data'] != null) {
          // 트레이너 이름
          if (response.data['data']['trainerName'] != null) {
            _trainerName = response.data['data']['trainerName'];
          }

          // 트레이너 프로필 이미지
          if (response.data['data']['trainerProfile'] != null) {
            print(response.data['data']['trainerProfile']);
            _trainerProfile = response.data['data']['trainerProfile'];
          }

          // 트레이너 코멘트
          if (response.data['data']['trainerComment'].length > 0) {
            final parsedDate = DateTime.parse(
                response.data['data']['trainerComment'][0]['date']);
            final parsedCreatedAt = DateTime.parse(
                response.data['data']['trainerComment'][0]['createdAt']);
            _trainerComment = Comment(
              response.data['data']['trainerComment'][0]['comment'],
              id: response.data['data']['trainerComment'][0]['id'],
              date: parsedDate,
              createdAt: parsedCreatedAt,
            );
          } else {
            _trainerComment = null;
            print('코멘트 없음');
          }

          // 유저 체크리스트
          if (response.data['data']['checklist'].length > 0) {
            // 운동 리스트
            if (response.data['data']['checklist'][0]['workoutlist'] != null) {
              List workoutLists =
                  response.data['data']['checklist'][0]['workoutlist'];
              _workoutList = [];
              for (var workoutList in workoutLists) {
                DateTime _checkDate = workoutList['checkDate'] == null
                    ? null
                    : DateTime.parse(workoutList['checkDate'] as String);
                CheckList workout = CheckList(
                  workoutList['name'],
                  workoutList['contents'],
                  workoutList['isEditable'] ?? false,
                  outerId: response.data['data']['checklist'][0]['_id'],
                  checkDate: _checkDate,
                  innerId: workoutList['_id'],
                );
                _workoutList.add(workout);
              }
            }

            // 식단 리스트
            if (response.data['data']['checklist'][0]['dietlist'] != null) {
              List dietLists =
                  response.data['data']['checklist'][0]['dietlist'];
              _dietList = [];
              for (var dietList in dietLists) {
                DateTime _checkDate = dietList['checkDate'] == null
                    ? null
                    : DateTime.parse(dietList['checkDate'] as String);
                CheckList diet = CheckList(
                  dietList['name'],
                  dietList['contents'],
                  dietList['isEditable'] ?? false,
                  outerId: response.data['data']['checklist'][0]['_id'],
                  checkDate: _checkDate,
                  innerId: dietList['_id'],
                  time: dietList['time'],
                );
                _dietList.add(diet);
              }
            }
          } else {
            _workoutList = [];
            _dietList = [];
            notifyListeners();
            print('체크리스트 없음');
          }
          // 유저 관리일지
          if (response.data['data']['bodyLog'].length > 0) {
            Map<String, dynamic> _res = response.data['data']['bodyLog'][0];
            _bodyLog = BodyLog(
              _res['_id'],
              DateTime.parse(_res['date']),
            );
            if (_res['morningWeight'] != null)
              _bodyLog.morningWeight = _res['morningWeight'].toDouble();
            if (_res['morningBody'].length > 0)
              _bodyLog.morningBody = _res['morningBody'];
            if (_res['nightWeight'] != null)
              _bodyLog.nightWeight = _res['nightWeight'].toDouble();
            if (_res['nightBody'].length > 0)
              _bodyLog.nightBody = _res['nightBody'];
            if (_res['morningFood'].length > 0)
              _bodyLog.morningFood = _res['morningFood'];
            _bodyLog.morningFoodTitle = _res['morningFoodTitle'];
            if (_res['afternoonFood'].length > 0)
              _bodyLog.afternoonFood = _res['afternoonFood'];
            _bodyLog.afternoonFoodTitle = _res['afternoonFoodTitle'];
            if (_res['nightFood'].length > 0)
              _bodyLog.nightFood = _res['nightFood'];
            _bodyLog.nightFoodTitle = _res['nightFoodTitle'];
            if (_res['snack'].length > 0) _bodyLog.snack = _res['snack'];
          } else {
            print(response.data['data']);
            _bodyLog = BodyLog('', DateTime.now());
            print('바디로그 없음');
          }

          // 프리미엄 기간
          _startDate = DateTime.parse(response.data['data']['startDate']);
          _endDate = DateTime.parse(response.data['data']['endDate']);
        }

        notifyListeners();
        return null;
      } on DioError catch (e) {
        print(e.message);
        return e.message;
      }
    }
  }

  void toggleWorkoutCheckbox(int index) async {
    print(index);
    print(_workoutList[index].isEditable);
    if (_workoutList[index].isEditable != null){
      _workoutList[index].isEditable = !_workoutList[index].isEditable;
      if (_workoutList[index].isEditable){
        _workoutList[index].checkDate = DateTime.now();
      } else {
        _workoutList[index].checkDate = null;
      }
    }
    notifyListeners();

    if (dio == null) dio = Dio(options);

    if (_token == null) {
      print('checkbox click: token is null');
    } else {
      try {
        dio.options.headers['accesstoken'] = _token;
        await dio.put('premium/checklist/workoutlist/user/checkbox/$_premiumId', data: {
          "name": _workoutList[index].name,
          "contents": _workoutList[index].contents,
          "isEditable": _workoutList[index].isEditable,
          "workoutId": _workoutList[index].innerId,
          "checklistId": _workoutList[index].outerId,
        });
      } on DioError catch (e) {
        print('checkbox click: ${e.message}');
      }
    }
  }

  void toggleDietCheckbox(int index) async {
    _dietList[index].isEditable = !_dietList[index].isEditable;
    notifyListeners();

    if (dio == null) dio = Dio(options);

    if (_token == null) {
      print('checkbox click: token is null');
    } else {
      try {
        dio.options.headers['accesstoken'] = _token;
        await dio.put('premium/checklist/dietlist/user/checkbox/$_premiumId', data: {
          "name": _dietList[index].name,
          "contents": _dietList[index].contents,
          "isEditable": _dietList[index].isEditable,
          "dietId": _dietList[index].innerId,
          "checklistId": _dietList[index].outerId,
        });
      } on DioError catch (e) {
        print('checkbox click: ${e.message}');
      }
    }
  }

  void setFoodTitle(String title, String foodName) {
    print(foodName);
    switch (foodName) {
      case 'morningFoodTitle':
        _bodyLog.morningFoodTitle = title;
        notifyListeners();
        break;
      case 'afternoonFoodTitle':
        _bodyLog.afternoonFoodTitle = title;
        notifyListeners();
        break;
      case 'nightFoodTitle':
        _bodyLog.nightFoodTitle = title;
        notifyListeners();
        break;
      case 'snackTitle':
        _bodyLog.snackTitle = title;
        notifyListeners();
        break;
      default:
        print('default');
    }
  }

  Future<String> postUploadAvatar(File file) async {
    if (dio == null) dio = Dio(options);
    String fileName = file.path.split('/').last;
    String mimeType = mime(fileName);
    String mimee = mimeType.split('/')[0];
    String type = mimeType.split('/')[1];
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path,
          filename: fileName, contentType: MediaType(mimee, type)),
    });
    String _photoUrl = '';
    try {
      Response response = await dio.post('file/upload/avatar', data: formData);
      if (response.data['photoUrl'] != null)
        _photoUrl = response.data['photoUrl'];
      return _photoUrl;
    } on DioError catch (e) {
      print(e.message);
      return '';
    }
  }

  Future<void> postUploadImage(File file, String imageName) async {
    if (dio == null) dio = Dio(options);

    String fileName = file.path.split('/').last;
    String mimeType = mime(fileName);
    String mimee = mimeType.split('/')[0];
    String type = mimeType.split('/')[1];

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path,
          filename: fileName, contentType: MediaType(mimee, type)),
      "imageName": imageName,
      "date": selectedDay,
    });

    try {
      dio.options.headers["accesstoken"] = _token;
      Response response =
          await dio.post('file/upload/$premiumId', data: formData);

      if (response.data['photoUrl'] != null) {
        switch (imageName) {
          case 'morningBody':
            _bodyLog.morningBody.add(response.data['photoUrl']);
            notifyListeners();
            break;
          case 'nightBody':
            _bodyLog.nightBody.add(response.data['photoUrl']);
            notifyListeners();
            break;
          case 'morningFood':
            _bodyLog.morningFood.add(response.data['photoUrl']);
            notifyListeners();
            break;
          case 'afternoonFood':
            _bodyLog.afternoonFood.add(response.data['photoUrl']);
            notifyListeners();
            break;
          case 'nightFood':
            _bodyLog.nightFood.add(response.data['photoUrl']);
            notifyListeners();
            break;
          case 'snack':
            _bodyLog.snack.add(response.data['photoUrl']);
            notifyListeners();
            break;
          default:
            print('default');
        }
      }
      print('image upload res: ${response.data['photoUrl']}');
    } on DioError catch (e) {
      print(e.message);
    }
  }

  Future<void> postDeleteImage(String filePath, String imageName) async {
    if (dio == null) dio = Dio(options);

    try {
      dio.options.headers["accesstoken"] = _token;
      Response response = await dio.delete('file/delete/$premiumId', data: {
        "date": _selectedDay.toIso8601String(),
        "imageName": imageName,
        "path": filePath,
      });
      print(response);
      getPremiumUserData(date: _selectedDay);
      notifyListeners();
    } on DioError catch (e) {
      print(e.message);
    }
  }

  Future<void> postUploadWeight(String weight, String weightName) async {
    if (dio == null) dio = Dio(options);

    try {
      dio.options.headers["accesstoken"] = "$token";
      Response response = await dio.post(
        'premium/diary/weight/$premiumId',
        data: {
          "date": _selectedDay.toIso8601String(),
          "weight": weight,
          "weightName": weightName,
        },
      );
      if (response.data['success'] != null) {
        switch (weightName) {
          case 'morningWeight':
            _bodyLog.morningWeight = double.parse(weight);
            notifyListeners();
            break;
          case 'nightWeight':
            _bodyLog.nightWeight = double.parse(weight);
            notifyListeners();
            break;
          default:
            print('default');
        }
      }
      print(response.data['success']);
    } on DioError catch (e) {
      print(e.message);
    }
  }

  Future<void> postUploadFoodTitle(String foodName) async {
    if (dio == null) dio = Dio(options);
    print('postUploadFoodTitle');
    String _title;
    switch (foodName) {
      case 'morningFoodTitle':
        _title = _bodyLog.morningFoodTitle;
        break;
      case 'afternoonFoodTitle':
        _title = _bodyLog.afternoonFoodTitle;
        break;
      case 'nightFoodTitle':
        _title = _bodyLog.nightFoodTitle;
        break;
      case 'snackTitle':
        _title = _bodyLog.snackTitle;
        break;
      default:
        print('default');
    }
    try {
      dio.options.headers["accesstoken"] = "$token";
      Response response = await dio.post(
        'premium/diary/foodtitle/$premiumId',
        data: {
          "date": _selectedDay.toIso8601String(),
          "title": _title,
          "foodName": foodName,
        },
      );
      print('success: ${response.data['success']}');
    } on DioError catch (e) {
      print(e.message);
    }
  }
}
