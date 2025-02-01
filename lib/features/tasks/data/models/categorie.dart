class Category {
  final String idCategorie;
  final String nameCategorie;

  Category({required this.idCategorie, required this.nameCategorie});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      idCategorie: json['idCategorie'] as String,
      nameCategorie: json['nameCategorie'] as String,
    );
  }
}

