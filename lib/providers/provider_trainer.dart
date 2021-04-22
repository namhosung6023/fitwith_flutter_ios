import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fitwith/config/env.dart';
import 'package:fitwith/models/model_bodylog.dart';
import 'package:fitwith/models/model_checklist.dart';
import 'package:fitwith/models/model_comment.dart';
import 'package:fitwith/models/model_member.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Trainer extends ChangeNotifier {
  static String _token;
  static String _type;
  static String _trainerId;
  static String _premiumId;
  static List<Member> _memberList = [];
  static DateTime _selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  static String _selectedUserPremiumId;
  static String _selectedUsername;
  static int _selectedUserAge;
  static String _selectedUserGender;
  static int _selectedUserTrainingDays;

  static Comment _trainerComment = Comment('');

  static List<CheckList> _workoutList = [];
  static List<CheckList> _dietList = [
    CheckList('', '', false, time: 0),
    CheckList('', '', false, time: 1),
    CheckList('', '', false, time: 2),
    CheckList('', '', false, time: 3),
  ];
  static BodyLog _bodyLog;

  String get token => _token;
  String get type => _type ?? '';
  set trainerId(String id) => _trainerId = id;
  String get premiumId => _premiumId;

  List<Member> get memberList => _memberList;
  DateTime get selectedDay => _selectedDay;

  String get selectedUserPremiumId => _selectedUserPremiumId;
  String get selectedUsername => _selectedUsername;
  int get selectedUserAge => _selectedUserAge;
  String get selectedUserGender => _selectedUserGender;
  int get selectedUserTrainingDays => _selectedUserTrainingDays;

  Comment get trainerComment => _trainerComment;

  List<CheckList> get workoutList => _workoutList;
  List<CheckList> get dietList => _dietList;
  get bodyLog => _bodyLog;

  void setTrainerComment(String value) {
    _trainerComment.comment = value;
    notifyListeners();
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    return _token;
  }

  Dio dio;
  BaseOptions options = dioOptions;

  Future<String> getMemberList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');

    if (dio == null) dio = Dio(options);
    if (_token == null) {
      print('token is null');
    } else {
      try {
        dio.options.headers['accesstoken'] = _token;
        Response response = await dio.get('premium/userlist/$_trainerId');
        if (response.data['memberList'].length > 0) {
          List memberList = response.data['memberList'];
          _memberList = [];
          for (var i = 0; i < memberList.length; i++) {
            DateTime startDate = DateFormat('yyyy-MM-dd')
                .parse(memberList[i]['premium']['startDate']);
            DateTime endDate = DateFormat('yyyy-MM-dd')
                .parse(memberList[i]['premium']['endDate']);
            String _avatar;
            if(memberList[i]['user']['avatar'] != null && memberList[i]['user']['avatar'] != ''){
              _avatar = memberList[i]['user']['avatar'];
            } else {
              _avatar = 'https://thumbs.dreamstime.com/b/default-avatar-profile-image-vector-social-media-user-icon-potrait-182347582.jpg';
            }

            Member _member = Member(
              memberList[i]['user']['username'],
              memberList[i]['user']['age'],
              memberList[i]['user']['gender'],
              startDate,
              endDate,
              _avatar,
              memberList[i]['premium']['_id'],
            );
            _memberList.add(_member);
          }
        } else {
          _memberList = [];
          print('맴버리스트 없음');
        }
        notifyListeners();
        return null;
      } on DioError catch (e) {
        print(e.message);
      }
    }
  }

  void selectUser(
    String premiumId,
    String username,
    int age,
    String gender,
    int days,
  ) {
    _selectedUserPremiumId = premiumId;
    _selectedUsername = username;
    _selectedUserAge = age;
    _selectedUserGender = gender;
    _selectedUserTrainingDays = days;
  }

  void postTrainerComment() async {
    if (dio == null) dio = Dio(options);

    if (_token == null) {
      print('token is null');
    } else {
      try {
        dio.options.headers['accesstoken'] = _token;
        Response response = await dio
            .post('premium/comment/update/$_selectedUserPremiumId', data: {
          "date": _selectedDay.toString(),
          "comment": _trainerComment.comment
        });

        if (response.data['data'] != null) {
          final parsedDate = DateTime.parse(response.data['data']['date']);
          final parsedCreatedAt =
              DateTime.parse(response.data['data']['createdAt']);

          _trainerComment.comment = response.data['data']['comment'];
          _trainerComment.id = response.data['data']['_id'];
          _trainerComment.date = parsedDate;
          _trainerComment.createdAt = parsedCreatedAt;
        }
      } on DioError catch (e) {
        print('dio error: ${e.message}');
      }
    }
  }

  Future<String> getPremiumUserData({DateTime date}) async {
    print(date);
    if (date != null) _selectedDay = DateTime(date.year, date.month, date.day);

    if (dio == null) dio = Dio(options);

    if (_token == null) {
      return 'token is null';
    } else {
      try {
        dio.options.headers['accesstoken'] = _token;
        Response response = await dio.get(
            'premium/user/$_selectedUserPremiumId',
            queryParameters: {"date": _selectedDay});

        // 트레이너 코멘트
        if (response.data['data'] != null &&
            response.data['data']['trainerComment'].length > 0) {
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
          _trainerComment = Comment('');
          print('코멘트 없음');
        }

        // 유저 체크리스트
        _workoutList = [];
        if (response.data['data'] != null &&
            response.data['data']['checklist'].length > 0) {
          // 운동 리스트
          if (response.data['data']['checklist'][0]['workoutlist'] != null) {
            List workoutLists =
                response.data['data']['checklist'][0]['workoutlist'];
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
          } else {
            _workoutList = [];
          }

          // 식단 리스트
          if (response.data['data']['checklist'][0]['dietlist'] != null) {
            List dietLists = response.data['data']['checklist'][0]['dietlist'];
            _dietList = [
              CheckList('', '', false, time: 0),
              CheckList('', '', false, time: 1),
              CheckList('', '', false, time: 2),
              CheckList('', '', false, time: 3),
            ];
            for (var dietList in dietLists) {
              DateTime _checkDate = dietList['checkDate'] == null
                  ? null
                  : DateTime.parse(dietList['checkDate'] as String);
              CheckList diet = CheckList(
                dietList['name'],
                dietList['contents'],
                dietList['isEditable'],
                outerId: response.data['data']['checklist'][0]['_id'],
                checkDate: _checkDate,
                innerId: dietList['_id'],
                time: dietList['time'],
              );

              if (dietList['time'] == 0) {
                _dietList[0].name = diet.name;
                _dietList[0].contents = diet.contents;
                _dietList[0].isEditable = diet.isEditable;
                _dietList[0].checkDate = diet.checkDate;
              } else if (dietList['time'] == 1) {
                _dietList[1].name = diet.name;
                _dietList[1].contents = diet.contents;
                _dietList[1].isEditable = diet.isEditable;
                _dietList[1].checkDate = diet.checkDate;
              } else if (dietList['time'] == 2) {
                _dietList[2].name = diet.name;
                _dietList[2].contents = diet.contents;
                _dietList[2].isEditable = diet.isEditable;
                _dietList[2].checkDate = diet.checkDate;
              } else {
                _dietList[3].name = diet.name;
                _dietList[3].contents = diet.contents;
                _dietList[3].isEditable = diet.isEditable;
                _dietList[3].checkDate = diet.checkDate;
              }
            }
          }
        } else {
          _workoutList = [];
          _dietList = [
            CheckList('', '', false, time: 0),
            CheckList('', '', false, time: 1),
            CheckList('', '', false, time: 2),
            CheckList('', '', false, time: 3),
          ];
          print('체크리스트 없음');
        }

        // 유저 관리일지
        if (response.data['data'] != null &&
            response.data['data']['bodyLog'].length > 0) {
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
          _bodyLog = BodyLog('', DateTime.now());
          print('바디로그 없음');
        }
        notifyListeners();
        return null;
      } on DioError catch (e) {
        print(e.message);
        return e.message;
      }
    }
  }

  void addWorkoutList(String name, String contents, bool isEditable) {
    CheckList _workout = CheckList(name, contents, isEditable);
    _workoutList.add(_workout);
    notifyListeners();
    postWorkoutList();
  }

  void updateWorkoutList(int index, String name, String contents) {
    _workoutList[index].name = name;
    _workoutList[index].contents = contents;
    notifyListeners();
    postWorkoutList();
  }

  void reorderWorkoutList(int oldIndex, int newIndex) {
    print('reorder $oldIndex => $newIndex');
    print(_workoutList[oldIndex].checkDate);
    if (newIndex > _workoutList.length) {
      newIndex = _workoutList.length;
    }
    if (oldIndex < newIndex) {
      newIndex--;
    }

    CheckList item = _workoutList[oldIndex];
    print(item.checkDate);
    _workoutList.remove(item);
    _workoutList.insert(newIndex, item);
    print('111');
    print(_workoutList[newIndex].checkDate);

    notifyListeners();
    postWorkoutList();
  }

  void postWorkoutList() async {
    if (dio == null) dio = Dio(options);
    if (_token == null)
      print('postWorkoutList: token is null');
    else {
      try {
        dio.options.headers['accesstoken'] = _token;
        Response response = await dio.post(
            'premium/checklist/workoutlist/trainer/$_selectedUserPremiumId',
            data: {
              "date": _selectedDay.toIso8601String(),
              "workoutlist":
                  jsonEncode(_workoutList.map((e) => e.toJson()).toList()),
            });
        // if (response.data['success']) {
        //   getPremiumUserData();
        //   notifyListeners();
        // }
      } on DioError catch (e) {
        print('postWorkoutList: ${e.message}');
      }
    }
  }

  void deleteWorkoutList(
      String checklistId, String workoutId, int index) async {
    if (dio == null) {
      dio = Dio(options);
    }

    if (_token == null) {
      print('deleteWorkoutList: token is null');
    } else {
      try {
        dio.options.headers['accesstoken'] = _token;
        Response response = await dio.delete(
            'premium/checklist/workoutlist/delete/$_selectedUserPremiumId',
            data: {
              "workoutId": workoutId,
              "checklistId": checklistId,
            });
      } on DioError catch (e) {
        print('deleteWorkoutList: ${e.message}');
      }
    }
    _workoutList.removeAt(index);
    notifyListeners();
  }

  // void addDietList(String name, String contents, int time) {
  //   for(int i = 0; i < 4; i++) {
  //
  //   }
  //   if (_dietList[time] != null) {
  //     _dietList[time] =
  //         CheckList(name, contents, time: time);
  //   }
  //   notifyListeners();
  //   postDietList();
  // }

  void updateDietList(String name, String contents, int time) {
    if (_dietList[time] != null) {
      _dietList[time].name = name;
      _dietList[time].contents = contents;
    }
    notifyListeners();
    postDietList();
  }

  Future<void> postDietList() async {
    if (dio == null) dio = Dio(options);
    if (_token == null)
      print('postDietList: token is null');
    else {
      try {
        dio.options.headers['accesstoken'] = _token;
        Response response = await dio.post(
          'premium/checklist/dietlist/trainer/$_selectedUserPremiumId',
          data: {
            "date": _selectedDay.toIso8601String(),
            "dietlist":
                jsonEncode(_dietList.map((e) => e.toJsonDiet()).toList()),
          },
        );
        if (response.data['success']) {
          getPremiumUserData();
        }
      } on DioError catch (e) {
        print('postDietList: ${e.message}');
      }
    }
  }
}
