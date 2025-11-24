import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/cart_provider.dart';
import '../../services/database_service.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Chip(label: Text('\$${cart.totalAmount.toStringAsFixed(2)}')),
                  TextButton(
                    child: Text('ORDER NOW'),
                    onPressed: (cart.totalAmount <= 0) ? null : () async {
                      // Create Order Object
                      final orderData = {
                        'userId': user!.uid,
                        'amount': cart.totalAmount,
                        'products': cart.items.values.map((cp) => {
                          'productId': cp.productId,
                          'title': cp.name,
                          'quantity': cp.quantity,
                          'price': cp.price,
                        }).toList(),
                        'date': DateTime.now().toIso8601String(),
                        'status': 'Processing', // Order Tracking Status
                      };

                      await DatabaseService().placeOrder(user.uid, orderData);
                      cart.clear();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order Placed Successfully!')));
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) {
                final item = cart.items.values.toList()[i];
                return Dismissible(
                  key: ValueKey(item.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    cart.removeItem(cart.items.keys.toList()[i]);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(child: Padding(padding: EdgeInsets.all(5), child: FittedBox(child: Text('\$${item.price}')))),
                    title: Text(item.name),
                    subtitle: Text('Total: \$${(item.price * item.quantity)}'),
                    trailing: Text('${item.quantity} x'),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}