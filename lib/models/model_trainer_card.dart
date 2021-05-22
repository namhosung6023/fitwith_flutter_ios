class TrainerCard {
  String trainerId;
  String username;
  String profileImage;
  List<String> field;
  String trainerIntro;
  String gender;
  String address;

  TrainerCard(
    this.trainerId,
    this.username,
    this.profileImage,
    this.field,
    this.trainerIntro, {
    this.gender,
    this.address,
  });
}
