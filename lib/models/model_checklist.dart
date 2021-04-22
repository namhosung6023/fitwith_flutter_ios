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
    return {
      'name': name,
      'contents': contents,
      'isEditable': isEditable ?? false,
      'checkDate': checkDate ?? '',
    };
  }

  Map<String, dynamic> toJsonDiet() {
    return {
      'time': time,
      'name': name,
      'contents': contents,
      'isEditable': isEditable ?? false,
      'checkDate': checkDate,
    };
  }
}
