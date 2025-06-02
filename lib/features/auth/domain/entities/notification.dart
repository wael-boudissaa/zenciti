class FriendRequestList {
  final String idFriendship;
  final String username;
  final String status;
  final DateTime createdAt;

  FriendRequestList({
    required this.idFriendship,
    required this.username,
    required this.status,
    required this.createdAt,
  });

  factory FriendRequestList.fromJson(Map<String, dynamic> json) {
    return FriendRequestList(
      idFriendship: json['idFriendship'] as String,
        username: json['username'] as String,

      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idFriendship': idFriendship,
      'status': status,
        'username': username,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
