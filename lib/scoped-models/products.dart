import 'package:flutter_course/models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';

class ProductsModel extends Model {
  List<Product> _products = [];
  int _selectedIndex;
  Product _selectedProduct;
  bool _isFavorite = false;

  bool get isFavorite {
    return _isFavorite;
  }

  int get selectedIndex {
    return _selectedIndex;
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

  List<Product> get product {
    return List.from(_products);
  }

  void addProduct(Product product) {
    _products.add(product);
  }

  void udpateProduct(Product product) {
    _products[selectedIndex] = product;
  }

  void deleteProduct(int index) {
    _products.removeAt(index);
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = _products[_selectedIndex].isFavorite;
    final bool newIsCurrentlyFavorite = !isCurrentlyFavorite;
    final Product productToBeUpdated = Product(
        title: _products[_selectedIndex].title,
        description: _products[_selectedIndex].description,
        price: _products[_selectedIndex].price,
        isFavorite: newIsCurrentlyFavorite,
        image: _products[_selectedIndex].image);

    udpateProduct(productToBeUpdated);
    notifyListeners();
  }

  List<Product> displayListProducts() {
    if (_isFavorite) {
      return _products.where((product) => product.isFavorite).toList();
    }
    return _products;
  }

  void toggleDisplayProducts() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }
}
