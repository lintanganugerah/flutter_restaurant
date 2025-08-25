import 'package:restaurant_flutter/type/menu_type.dart';

class MenuItem {
  String name;

  MenuItem({required this.name});

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      MenuItem(name: json["name"]);

  Map<String, dynamic> toJson() => {"name": name};
}

class Menu {
  List<MenuItem> foods;
  List<MenuItem> drinks;

  Menu({required this.foods, required this.drinks});

  List<MenuItem> getListByType(MenuType type) {
    switch (type) {
      case MenuType.foods:
        return foods;
      case MenuType.drinks:
        return drinks;
    }
  }

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
    foods: List<MenuItem>.from(json["foods"].map((x) => MenuItem.fromJson(x))),
    drinks: List<MenuItem>.from(
      json["drinks"].map((x) => MenuItem.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
    "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
  };
}
