import 'package:shop_app/providers/cart.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.products,
      @required this.dateTime,
      @required this.amount});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    try {
      final url =
          'https://flutter-update-be562-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
            id: orderId,
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                      title: item['title'],
                      price: item['price'],
                      id: item['id'],
                      quantity: item['quantity']),
                )
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime']),
            amount: orderData['amount']));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addOrder(
    List<CartItem> cartProducts,
    double total,
  ) async {
    final timeStamp = DateTime.now();
    final url =
        'https://flutter-update-be562-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
          'dateTime': timeStamp.toIso8601String(),
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            products: cartProducts,
            dateTime: timeStamp,
            amount: total));
    notifyListeners();
  }
}
