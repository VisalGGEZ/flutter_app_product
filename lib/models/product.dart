import 'package:flutter/material.dart';

class Product {
    String title;
    String image;
    String description;
    double price;
    bool isFavorite;

  Product(
      {@required this.title,
      @required this.image,
      @required this.description,
      @required this.price,
      @required this.isFavorite});
}