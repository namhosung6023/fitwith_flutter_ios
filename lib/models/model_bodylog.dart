class BodyLog {
  String id;
  DateTime date;

  List morningBody = [];
  num morningWeight;
  List nightBody = [];
  num nightWeight;
  List morningFood = [];
  String morningFoodTitle = '';
  List afternoonFood = [];
  String afternoonFoodTitle = '';
  List nightFood = [];
  String nightFoodTitle = '';
  List snack = [];
  String snackTitle = '';

  BodyLog(this.id, this.date);
}
