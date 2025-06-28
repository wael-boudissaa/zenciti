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

class Activity {
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

class ActivityProfile {
  String idActivity;
  String nameActivity;
  String descriptionActivity;
  String imageActivity;
  int popularity;
  DateTime timeActivity;
  ActivityProfile({
    required this.idActivity,
    required this.nameActivity,
    required this.descriptionActivity,
    required this.imageActivity,
    required this.popularity,
    required this.timeActivity,
  });
  factory ActivityProfile.fromJson(Map<String, dynamic> json) {
    return ActivityProfile(
      idActivity: json['idActivity'],
      nameActivity: json['nameActivity'],
      descriptionActivity: json['descriptionActivity'],
      imageActivity: json['imageActivity'],
      popularity: json['popularity'],
      timeActivity: DateTime.parse(json['timeActivity']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'idActivity': idActivity,
      'nameActivity': nameActivity,
      'descriptionActivity': descriptionActivity,
      'imageActivity': imageActivity,
      'popularity': popularity,
      'timeActivity': timeActivity.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ActivityProfile{idActivity: $idActivity, nameActivity: $nameActivity, descriptionActivity: $descriptionActivity, imageActivity: $imageActivity, popularity: $popularity, timeActivity: $timeActivity}';
  }
}

class ActivityClient {
  String idClientActivity;
  String activityName;
  String activityDescription;
  String activityImage;
  String status;
  DateTime timeActivity;
  ActivityClient({
    required this.idClientActivity,
    required this.activityName,
    required this.activityDescription,
    required this.activityImage,
    required this.status,
    required this.timeActivity,
  });
  factory ActivityClient.fromJson(Map<String, dynamic> json) {
    return ActivityClient(
      idClientActivity: json['idClientActivity'],
      activityName: json['activityName'],
      activityDescription: json['activityDescription'],
      activityImage: json['activityImage'],
      status: json['status'],
      timeActivity: DateTime.parse(json['timeActivity']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'idClientActivity': idClientActivity,
      'activityName': activityName,
      'activityDescription': activityDescription,
      'activityImage': activityImage,
      'status': status,
      'timeActivity': timeActivity.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ActivityClient{idClientActivity: $idClientActivity, activityName: $activityName, activityDescription: $activityDescription, activityImage: $activityImage, status: $status, timeActivity: $timeActivity}';
  }
}
