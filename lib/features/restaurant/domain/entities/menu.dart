class Menu {
  final String id;
  final String name;
  final String idRestaurant;
  final int active;
  final String? createdAt;

  Menu({
    required this.id,
    required this.idRestaurant,
    required this.active,
    this.createdAt,
    required this.name,
  });
  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
        id: json['idMenu'],
        idRestaurant: json['idRestaurant'],
        name: json['name'],
        active: json['active'],
        createdAt: json['createdAt']);
  }

  Map<String, dynamic> toJson() {
    return {
      'idMenu': id,
      'idRestaurant': idRestaurant,
      'name': name,
      'active': active,
      'createdAt': createdAt
    };
  }
}

class MenuItem {
  final String idMenu;
  final String menuName;
  final String idFood;
  final String idCategory;
  final String name;
  final String? description;
  final String? image;
  final double price;
  final String status;

  MenuItem({
    required this.idMenu,
    required this.menuName,
    required this.idFood,
    required this.idCategory,
    required this.name,
    this.description,
    this.image,
    required this.price,
    required this.status,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      idMenu: json['idMenu'],
      menuName: json['menuName'],
      idFood: json['idFood'],
      idCategory: json['idCategory'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMenu': idMenu,
      'menuName': menuName,
      'idFood': idFood,
      'idCategory': idCategory,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'status': status,
    };
  }
}
