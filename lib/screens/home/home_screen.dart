import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../services/product_seeder.dart';
import '../cart/cart_screen.dart';
import '../profile/profile_screen.dart';
import '../product/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = "";
  String selectedBrand = "All";

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Product>>.value(
      value: DatabaseService().products,
      initialData: [],
      child: Scaffold(
        appBar: AppBar(
          title: Text('LaptopHarbor'),
          actions: [
            IconButton(
              icon: Icon(Icons.cloud_upload, color: Colors.red), // Red so you see it easily
              onPressed: () async {
                // Import this at the top: import '../../services/product_seeder.dart';
                await ProductSeeder().uploadSampleProducts();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Products Uploaded! Refresh the app.'))
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen())),
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen())),
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => AuthService().signOut(),
            ),
          ],
        ),
        body: Column(
          children: [
            // Search and Filter
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Laptops...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => setState(() => searchQuery = val),
              ),
            ),
            // Category/Brand Filter Row (Simple Implementation)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Dell', 'Apple', 'HP', 'Lenovo'].map((brand) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(brand),
                      selected: selectedBrand == brand,
                      onSelected: (bool selected) {
                        setState(() => selectedBrand = brand);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: ProductList(searchQuery: searchQuery, brandFilter: selectedBrand),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  final String searchQuery;
  final String brandFilter;

  ProductList({required this.searchQuery, required this.brandFilter});

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<List<Product>>(context);

    // Client-side filtering
    final filteredProducts = products.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesBrand = brandFilter == 'All' || product.brand == brandFilter;
      return matchesSearch && matchesBrand;
    }).toList();

    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (ctx, i) {
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: filteredProducts[i]))),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Image.network(filteredProducts[i].imageUrl, fit: BoxFit.cover,
                      errorBuilder: (c,o,s) => Icon(Icons.laptop, size: 50),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(filteredProducts[i].name, style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('\$${filteredProducts[i].price}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}