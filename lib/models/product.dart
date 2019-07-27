import 'package:flutter/material.dart';

class Product {
  String id;
  String title;
  String image;
  String description;
  double price;
  bool isFavorite;
  String userId;
  String userEmail;

  Product(
      {@required this.id,
      @required this.title,
      @required this.image,
      @required this.description,
      @required this.price,
      this.isFavorite = false,
      @required this.userId,
      @required this.userEmail});
}
