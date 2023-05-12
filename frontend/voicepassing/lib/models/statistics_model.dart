// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  List<int> categoryNum;

  CategoryModel({
    required this.categoryNum,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        categoryNum: List<int>.from(json["categoryNum"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "categoryNum": List<dynamic>.from(categoryNum.map((x) => x)),
      };
}
