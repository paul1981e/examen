import 'dart:convert';

class Category {
  Category({
    required this.categoryId,
    required this.categoryName,
    required this.categoryState,
  });

  int categoryId;
  String categoryName;
  String categoryState;

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        categoryState: json["category_state"],
      );

  Map<String, dynamic> toMap() => {
        "category_id": categoryId,
        "category_name": categoryName,
        "category_state": categoryState,
      };
}

class CategoryList {
  CategoryList({
    required this.categories,
  });

  List<Category> categories;

  factory CategoryList.fromJson(String str) => CategoryList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CategoryList.fromMap(Map<String, dynamic> json) {
  if (json.containsKey("Listado Categorias")) {
    List<dynamic> categoryData = json["Listado Categorias"];
    List<Category> categories = categoryData.map((data) => Category.fromMap(data)).toList();
    return CategoryList(categories: categories);
  } else {
    throw Exception('Listado Categorias key not found in JSON');
  }
}


  Map<String, dynamic> toMap() => {
    "categories": List<dynamic>.from(categories.map((x) => x.toMap())),
  };
}