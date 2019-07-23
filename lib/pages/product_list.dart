import 'package:flutter/material.dart';
import 'package:flutter_course/pages/product_edit.dart';
import 'package:flutter_course/scoped-models/main-model.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductListPage extends StatelessWidget {
  Widget _buildListProduct(MainModel model) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            Dismissible(
              key: Key(model.allProducts[index].title),
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
                  child: Image.asset(model.allProducts[index].image),
                ),
                title: Text(model.allProducts[index].title),
                subtitle: Text('\$ ${model.allProducts[index].price}'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    model.setSelectedIndex(index);
                    model.setSelectedProduct(model.allProducts[index]);
                    model.setUpdateMode(true);
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
      itemCount: model.allProducts.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return _buildListProduct(model);
    });
  }
}
