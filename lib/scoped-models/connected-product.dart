import 'dart:convert' as convert;

import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

mixin ConnectedProductModel on Model {
  User authenticateUser;
  List<Product> products = [];
  int _selectedIndex;

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

  void fetchProruduct() {
    http
        .get('https://ezwallpaper-b95a5.firebaseio.com/products.json')
        .then((http.Response response) {
      final List<Product> tempProductList = [];
      final Map<String, dynamic> productsData =
          convert.jsonDecode(response.body);
      productsData.forEach((String productId, dynamic productsData) {
        final Product tempProduct = Product(
            id: productId,
            title: productsData['title'],
            price: productsData['price'],
            image: productsData['image'],
            description: productsData['description'],
            isFavorite: productsData['isFavorite'],
            userEmail: productsData['userEmail'],
            userId: productsData['userId']);
        tempProductList.add(tempProduct);
      });
      products = tempProductList;
      print(products);
      notifyListeners();
    });
  }

  void addProduct(String title, String description, double price) {
    final Map<String, dynamic> productData = {
      'title': title,
      'image':
          'https://amp.insider.com/images/5a395a06fcdf1e2d008b461b-750-563.jpg',
      'description': description,
      'price': price,
      'userId': authenticateUser.id,
      'userEmail': authenticateUser.email
    };

    http
        .post('https://ezwallpaper-b95a5.firebaseio.com/products.json',
            body: convert.json.encode(productData))
        .then((http.Response response) {
      Map<String, dynamic> productRes = convert.json.decode(response.body);
      print(productRes);

      // products.add(Product(
      
      // ));
      // _selectedIndex = null;
    });
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
        id: selectedProduct.id,
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
