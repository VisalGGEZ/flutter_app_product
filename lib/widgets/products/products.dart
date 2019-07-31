import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped-models/main-model.dart';
import 'package:scoped_model/scoped_model.dart';
import '../ui_elements/my-loading.dart';


import './product_card.dart';

class Products extends StatelessWidget {
  Widget _buildProductList(List<Product> products) {
    Widget productCards;
    if (products.length > 0 || products == null) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(products[index], index),
        itemCount: products.length,
      );
    } else {
      productCards = Container();
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget widget, MainModel model) {
        Widget content;
        if (model.isLoading) {
          content = Container(
            color: Theme.of(context).accentColor,
            child: MyLoading(),
          );
        } else {
          if (model.displayListProducts().length == 0) {
            content = Center(
              child: Text('No Data'),
            );
          } else {
            content = _buildProductList(model.displayListProducts());
          }
        }
        return content;
      },
    );
  }
}
