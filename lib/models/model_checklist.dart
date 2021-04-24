class CheckList {
  String name;
  String contents;
  bool isEditable = false;
  String outerId;
  DateTime checkDate;
  String innerId;
  int time;

  CheckList(
    this.name,
    this.contents,
    this.isEditable, {
    this.outerId,
    this.checkDate,
    this.innerId,
    this.time,
  });

  CheckList.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        contents = json['contents'],
        isEditable = json['isEditable'],
        checkDate = json['checkDate'];

  Map<String, dynamic> toJson() {
    if(checkDate == null) {
    return {
      'name': name,
      'contents': contents,
      'isEditable': isEditable ?? false,
      'checkDate' : '',
    };
    } else {
      return {
        'name': name,
        'contents': contents,
        'isEditable': isEditable ?? false,
        'checkDate' : checkDate.toIso8601String(),
      };
    }
  }

  Map<String, dynamic> toJsonDiet() {
    if(checkDate == null) return {
      'time': time,
      'name': name,
      'contents': contents,
      'isEditable': isEditable ?? false,
      'checkDate': '',
    };
    else return {
    'time': time,
    'name': name,
    'contents': contents,
    'isEditable': isEditable ?? false,
    'checkDate': checkDate.toIso8601String(),
    };
  }
}
