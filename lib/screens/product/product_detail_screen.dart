import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[200],
              child: Image.network(product.imageUrl, fit: BoxFit.cover,
                  errorBuilder: (c,o,s) => Icon(Icons.laptop, size: 100)),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('\$${product.price}', style: TextStyle(fontSize: 24, color: Colors.green)),
                  SizedBox(height: 10),
                  Text(product.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Brand: ${product.brand}'),
                  Divider(),
                  Text('Specifications:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...product.specs.entries.map((e) => Text('${e.key}: ${e.value}')).toList(),
                  Divider(),
                  Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(product.description),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      child: Text('Add to Cart', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        cart.addItem(product.id, product.price, product.name, product.imageUrl);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added to cart!')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}