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
      idTypeActivity: json['idTypeActivity'], // typo preserved as in Go
      nameTypeActivity: json['nameTypeActivity'],
      imageActivity: json['imageActivity'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'idTypeActivity': idTypeActivity,
      'nameTypeActivity': nameTypeActivity,
      'imageActivity': imageActivity,
    };
  }

  @override
  String toString() {
    return 'TypeActivity{idTypeActivity: $idTypeActivity, nameTypeActivity: $nameTypeActivity, imageActivity: $imageActivity}';
  }
}

class Activity{
    String idActivity;
    String nameActivity;
    String descriptionActivity;
    String typeActivity;
    String imageActivity;
    int popularity;
    Activity({
        required this.idActivity,
        required this.nameActivity,
        required this.descriptionActivity,
        required this.typeActivity,
        required this.imageActivity,
        required this.popularity,
    });
    factory Activity.fromJson(Map<String, dynamic> json) {
        return Activity(
        idActivity: json['idActivity'],
        nameActivity: json['nameActivity'],
        descriptionActivity: json['descriptionActivity'],
        typeActivity: json['idTypeActivity'],
        imageActivity: json['imageActivity'],
        popularity: json['popularity'],
        );
    }
    Map<String, dynamic> toJson() {
        return {
        'idActivity': idActivity,
        'nameActivity': nameActivity,
        'descriptionActivity': descriptionActivity,
        'typeActivity': typeActivity,
        'imageActivity': imageActivity,
        'popularity': popularity,
        };
    }
    @override
    String toString() {
        return 'Activity{idActivity: $idActivity, nameActivity: $nameActivity, descriptionActivity: $descriptionActivity, typeActivity: $typeActivity, imageActivity: $imageActivity, popularity: $popularity}';
    }
}
