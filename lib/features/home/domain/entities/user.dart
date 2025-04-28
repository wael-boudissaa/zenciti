class ActivityType {
  final String idTypeActivity;
  final String nameTypeActivity;
  final String imageActivity;

  ActivityType({
    required this.idTypeActivity,
    required this.nameTypeActivity,
    required this.imageActivity,
  });

  factory ActivityType.fromJson(Map<String, dynamic> json) {
    return ActivityType(
      idTypeActivity: json['idTypeAcitvity'], // typo preserved as in Go
      nameTypeActivity: json['nameTypeActivity'],
      imageActivity: json['imageActivity'],
    );
  }
}
