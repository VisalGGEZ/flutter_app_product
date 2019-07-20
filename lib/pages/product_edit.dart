import 'package:flutter/material.dart';
import 'package:flutter_course/helpers/ensure_visible.dart';
import 'package:flutter_course/models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_course/scoped-models/products.dart';

class ProductEditPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Product _formData = Product(
      title: null, price: null, description: null, image: 'assets/food.jpg', isFavorite: false);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isUpdate = false;
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  Widget _buildTitleTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      child: TextFormField(
        focusNode: _titleFocusNode,
        decoration: InputDecoration(labelText: 'Product Title'),
        initialValue: _formData.title,
        validator: (value) {
          if (value.isEmpty || value.length < 5) {
            return 'Field is required and it must be more than 5+ characters';
          }
          return null;
        },
        onSaved: (String value) {
          _formData.title = value;
        },
      ),
    );
  }

  Widget _buildDescriptionTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
        focusNode: _descriptionFocusNode,
        maxLines: 4,
        decoration: InputDecoration(labelText: 'Product Description'),
        initialValue: _formData.description,
        validator: (value) {
          if (value.isEmpty || value.length < 10) {
            return 'Field is required and it must be more than 10+ characters.';
          }
        },
        onSaved: (String value) {
          _formData.description = value;
        },
      ),
    );
  }

  Widget _buildPriceTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
        focusNode: _priceFocusNode,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Product Price'),
        initialValue:
            _formData.price == null ? null : _formData.price.toString(),
        validator: (value) {
          RegExp regExp = new RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$');
          if (!regExp.hasMatch(value)) {
            return 'Field is required and it support only digit';
          }
          return null;
        },
        onSaved: (String value) {
          _formData.price = double.parse(value);
        },
      ),
    );
  }

  void _submitForm(Function addProduct, Function updateProduct) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (_isUpdate) {
      print('update item');
      updateProduct(_formData);
    } else {
      print('create item');
      addProduct(_formData);
    }
    Navigator.pushReplacementNamed(context, '/products');
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        return RaisedButton(
          child: Text('Save'),
          textColor: Colors.white,
          onPressed: () => _submitForm(model.addProduct, model.udpateProduct),
        );
      },
    );
  }

  Widget pageContent(double targetPadding) {
    return Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildTitleTextField(),
              _buildDescriptionTextField(),
              _buildPriceTextField(),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton()
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return ScopedModelDescendant<ProductsModel>(builder: (BuildContext context, Widget child, ProductsModel model){
      if (model.selectedProduct == null) {
      return pageContent(targetPadding);
    } else {

      _formData.title = model.selectedProduct.title;
      _formData.description = model.selectedProduct.description;
      _formData.price = model.selectedProduct.price;

      return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
        ),
        body: pageContent(targetPadding),
      );
    }
    },);
  }
}
