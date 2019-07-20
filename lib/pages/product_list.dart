import 'package:flutter/material.dart';
import 'package:flutter_course/pages/product_edit.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/products.dart';

class ProductListPage extends StatelessWidget {
  Widget _buildListProduct(ProductsModel model) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            Dismissible(
              key: Key(model.product[index].title),
              background: Container(
                color: Colors.pinkAccent,
              ),
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  model.deleteProduct(index);
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Item ${(index + 1)} was delelted.'),
                  ));
                }
              },
              child: ListTile(
                leading: CircleAvatar(
                  child: Image.asset(model.product[index].image),
                ),
                title: Text(model.product[index].title),
                subtitle: Text('\$ ${model.product[index].price}'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    model.setSelectedIndex(index);
                    model.setSelectedProduct(model.product[index]);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => ProductEditPage()));
                  },
                ),
              ),
            ),
            Divider(),
          ],
        );
      },
      itemCount: model.product.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, ProductsModel model) {
      return _buildListProduct(model);
    });
  }
}
