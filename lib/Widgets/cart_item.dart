import 'package:flutter/material.dart';
import '../providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem({@required this.title,
    @required this.productId,
    @required this.price,
    @required this.id,
    @required this.quantity});

  @override
  Widget build(BuildContext context) {
    var total = price * quantity;
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme
            .of(context)
            .errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 15),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) =>
                AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('Do you want to remove item?'),
                  actions: [
                    FlatButton(onPressed: () {
                      Navigator.of(ctx).pop(false);
                    }, child: Text('No')),
                    FlatButton(onPressed: () {
                      Navigator.of(ctx).pop(true);
                    }, child: Text('Yes')),
                  ],
                ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                  padding: EdgeInsets.all(2),
                  child: FittedBox(
                      child: Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
            ),
            title: Text(title),
            subtitle: Text('Total: ${total.toStringAsFixed(2)} '),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
