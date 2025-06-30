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

class Food {
  final String idFood;
  final String name;
  final String? idRestaurant;
  final String? description;
  final String? image;
  final double? price;
  final String idCategory;
  final String status;

  Food({
    required this.idFood,
    required this.name,
    this.idRestaurant,
    this.price,
    this.description,
    this.image,
    required this.idCategory,
    required this.status,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      idFood: json['idFood'],
      name: json['name'],
      idRestaurant: json['idRestaurant'],
      description: json['description'],
      image: json['image'],
      price: json['price'],
      idCategory: json['idCategory'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idFood': idFood,
      'name': name,
      'idRestaurant': idRestaurant,
      'description': description,
      'price': price,
      'image': image,
      'idCategory': idCategory,
      'status': status,
    };
  }
}

class FoodItem {
  final String idFood;
  int quantity;
  final double priceSingle;

  FoodItem({
    required this.idFood,
    this.quantity = 0,
    required this.priceSingle,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      idFood: json['idFood'],
      quantity: json['quantity'],
      priceSingle: (json['priceSingle'] as num).toDouble(),
    );
  }
  FoodItem copyWith({int? quantity}) {
    return FoodItem(
      idFood: idFood,
      priceSingle: priceSingle,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idFood': idFood,
      'quantity': quantity,
      'priceSingle': priceSingle,
    };
  }
}

class MenuItem {
  final String idMenu;
  final String menuName;
  final String idFood;
  final String idCategory;
  final String idRestaurant;

  final String name;
  final String description;
  final String image;
  final double price;
  final String status;

  MenuItem({
    required this.idMenu,
    required this.menuName,
    required this.idRestaurant,
    required this.idFood,
    required this.idCategory,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.status,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      idMenu: json['idMenu'],
      menuName: json['menuName'],
        idRestaurant: json['idRestaurant'],
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
      'idFood': idFood,
      'idCategory': idCategory,
      'name': name,
      'description': description,
        'idRestaurant': idRestaurant,
      'image': image,
      'price': price,
      'menuName': menuName,
      'status': status,
    };
  }
}
