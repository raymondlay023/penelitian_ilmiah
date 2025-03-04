import 'package:catet_kas/models/product_model.dart';
import 'package:catet_kas/services/product_service.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider with ChangeNotifier {
  //initialize product & products
  List<ProductModel> _products = [];

  //getter setter products
  List<ProductModel> get products => _products;
  set products(List<ProductModel> products) {
    _products = products;
    notifyListeners();
  }

  Future<void> getProducts(String token) async {
    try {
      List<ProductModel> products = await ProductService().getProducts(token);
      _products = products;
    } catch (e) {
      print(e);
    }
  }

  Future<bool> update({
    required int id,
    required String token,
    required String name,
    required int stock,
    required double price,
    required double capital,
  }) async {
    try {
      await ProductService().update(
        token: token,
        id: id,
        name: name,
        stock: stock,
        price: price,
        capital: capital,
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> create({
    required String token,
    required String name,
    required double price,
    double capital = 0,
    int stock = 0,
  }) async {
    try {
      await ProductService().create(
        token: token,
        name: name,
        price: price,
        capital: capital,
        stock: stock,
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> delete({
    required String token,
    required int id,
  }) async {
    try {
      await ProductService().delete(
        token: token,
        id: id,
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  getProduct({required int id}) {
    int index = products.indexWhere((element) => element.id == id);
    if (index != 1) {
      return products[index];
    } else {
      return null;
    }
  }

  filteredProduct({required String query}) {
    return products.where((product) {
      final nameLower = product.name!.toLowerCase();
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower);
    }).toList();
  }
}
