import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

mixin ConnectedProductModel on Model {
  User authenticateUser;
  List<Product> products = [];
  int _selectedIndex;

  void addProduct(Product product) {
    product.userId = authenticateUser.id;
    product.userEmail = authenticateUser.email;
    product.image =
        'https://www.google.com/url?sa=i&source=images&cd=&ved=2ahUKEwi2jvrkucrjAhVRjuYKHeuyB08QjRx6BAgBEAU&url=http%3A%2F%2Fwww.peanutbutterandpeppers.com%2F2012%2F05%2F16%2Fpeppermint-mocha-frappe%2F&psig=AOvVaw2ZfOdZHngLOmCN87upkx8l&ust=1563951038227575';

    final Map<String, dynamic> productData = {
      'title': product.title,
      'image': product.image,
      'description': product.description,
      'price': product.price,
      'id': product.userId,
      'email': product.userEmail
    };

    http.post('https://ezwallpaper-b95a5.firebaseio.com/products.json',
        body: json.encode(productData));

    products.add(product);
    _selectedIndex = null;
  }

  Product _selectedProduct;
  bool _isFavorite = false;
  bool _isUpdate = false;

  bool get isUpdate {
    bool value = false;
    if (_isUpdate) {
      value = true;
      _isUpdate = false;
    }
    return value;
  }

  bool get isFavorite {
    return _isFavorite;
  }

  int get selectedIndex {
    return _selectedIndex;
  }

  void setUpdateMode(bool value) {
    _isUpdate = value;
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
  }

  Product get selectedProduct {
    return _selectedProduct;
  }

  void setSelectedProduct(Product product) {
    _selectedProduct = product;
  }

  List<Product> get allProducts {
    return List.from(products);
  }

  void udpateProduct(Product product) {
    products[selectedIndex] = product;
  }

  void deleteProduct(int index) {
    products.removeAt(index);
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newIsCurrentlyFavorite = !isCurrentlyFavorite;
    final Product productToBeUpdated = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        isFavorite: newIsCurrentlyFavorite,
        image: selectedProduct.image,
        userId: selectedProduct.userId,
        userEmail: selectedProduct.userEmail);

    udpateProduct(productToBeUpdated);
    notifyListeners();
  }

  List<Product> displayListProducts() {
    if (_isFavorite) {
      return products.where((product) => product.isFavorite).toList();
    }
    return products;
  }

  void toggleDisplayProducts() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }
}

mixin UserModel on ConnectedProductModel {
  void login(String email, String password) {
    authenticateUser = User(id: 'abc123erf2', email: email, password: password);
  }
}
