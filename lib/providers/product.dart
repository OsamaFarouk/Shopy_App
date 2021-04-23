import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false,
  });

  void setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> isFavoriteStatus(String token, String userId) async {
    final url =
        'https://flutter-update-be562-default-rtdb.firebaseio.com/userFavorite/$userId/$id.json?auth=$token';
    final oldStatuse = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavorite,
          ));
      if (response.statusCode >= 400) {
        setFavValue(oldStatuse);
      }
    } catch (error) {
      setFavValue(oldStatuse);
    }
  }
}
