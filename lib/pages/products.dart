import 'package:flutter/material.dart';
import 'package:flutter_course/scoped-models/main-model.dart';

import '../widgets/products/products.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/ui_elements/my-loading.dart';

class ProductsPage extends StatefulWidget {
  final MainModel model;

  ProductsPage({@required this.model});

  @override
  State<StatefulWidget> createState() {
    return _ProductsPageState();
  }
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    if (widget.model.displayListProducts().length == 0) {
      widget.model.fetchProruduct();
    }
    widget.model.setUpdateMode(false);
    super.initState();
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          )
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget widget, MainModel model) {
        Widget content;
        if (model.isLoading) {
          content = Container(
            color: Theme.of(context).accentColor,
            child: MyLoading(loadingSize: 50.0),
          );
        } else {
          if (model.displayListProducts().length == 0) {
            content = Center(
              child: Text('No Data'),
            );
          } else {
            content = Products();
          }
        }
        return content;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('EasyList'),
        actions: <Widget>[
          ScopedModelDescendant(
            builder: (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                icon: Icon(model.isFavorite == false
                    ? Icons.favorite_border
                    : Icons.favorite),
                onPressed: () {
                  model.toggleDisplayProducts();
                },
              );
            },
          )
        ],
      ),
      body: _buildProductList(),
    );
  }
}
