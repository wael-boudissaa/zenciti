class TypeActivity {
  String idTypeActivity;
  String nameTypeActivity;
  String imageActivity;
  TypeActivity({
    required this.idTypeActivity,
    required this.nameTypeActivity,
    required this.imageActivity,
  });
  factory TypeActivity.fromJson(Map<String, dynamic> json) {
    return TypeActivity(
      idTypeActivity: json['idTypeAcitvity'], // typo preserved as in Go
      nameTypeActivity: json['nameTypeActivity'],
      imageActivity: json['imageActivity'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'idTypeAcitvity': idTypeActivity,
      'nameTypeActivity': nameTypeActivity,
      'imageActivity': imageActivity,
    };
  }

  @override
  String toString() {
    return 'TypeActivity{idTypeActivity: $idTypeActivity, nameTypeActivity: $nameTypeActivity, imageActivity: $imageActivity}';
  }
}
