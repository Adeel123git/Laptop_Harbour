import 'package:cloud_firestore/cloud_firestore.dart';

class ProductSeeder {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> uploadSampleProducts() async {
    final CollectionReference productsRef = _db.collection('products');

    // List of dummy products
    List<Map<String, dynamic>> sampleProducts = [
      {
        'name': 'MacBook Air M2',
        'brand': 'Apple',
        'price': 1199.00,
        'rating': 4.8,
        'imageUrl': 'https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg', // Real Amazon Image Link
        'description': 'The redesigned MacBook Air is more portable than ever and weighs just 2.7 pounds. It’s the incredibly capable laptop that lets you work, play, or create just about anything — anywhere.',
        'specs': {
          'Processor': 'Apple M2',
          'RAM': '8GB',
          'Storage': '256GB SSD',
          'Display': '13.6" Liquid Retina'
        }
      },
      {
        'name': 'Dell XPS 13 Plus',
        'brand': 'Dell',
        'price': 1450.00,
        'rating': 4.5,
        'imageUrl': 'https://i.dell.com/is/image/DellContent/content/dam/ss2/product-images/dell-client-products/notebooks/xps-notebooks/xps-13-9320/media-gallery/xs9320nt-cnb-00055lf110-gy.psd?fmt=png-alpha&pscan=auto&scl=1&hei=402&wid=606&qlt=100,1&resMode=sharp2&size=606,402&chrss=full',
        'description': 'Twice as powerful as before in the same size. Features 12th Gen Intel Core processors and the latest battery technology, providing long battery life in a lightweight design.',
        'specs': {
          'Processor': 'Intel Core i7-1260P',
          'RAM': '16GB',
          'Storage': '512GB SSD',
          'Display': '13.4" FHD+'
        }
      },
      {
        'name': 'HP Spectre x360',
        'brand': 'HP',
        'price': 1250.00,
        'rating': 4.7,
        'imageUrl': 'https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c08038330.png',
        'description': 'Automatically adjusts to your surroundings. The HP Spectre x360 2-in-1 Laptop automatically adjusts to your surroundings to give you the best image and sound.',
        'specs': {
          'Processor': 'Intel Core i7-1255U',
          'RAM': '16GB',
          'Storage': '1TB SSD',
          'Display': '13.5" 3K2K OLED'
        }
      },
      {
        'name': 'Lenovo ThinkPad X1',
        'brand': 'Lenovo',
        'price': 1600.00,
        'rating': 4.9,
        'imageUrl': 'https://p1-ofp.static.pub/medias/bWFzdGVyfHJvb3R8NTQ2NDN8aW1hZ2UvcG5nfGg5OS9oZmIvMTE0MjQ2NDE0ODIzNjYucG5nfGI1NTMzMzc5MTA5Y2U4NjIzZDIxMzQ4ZGU0MTI4YzQ2OGE4M2FhZTM5ZjE0MDY4OTg5OWQxZTY1N2I5ZDA/lenovo-laptop-thinkpad-x1-carbon-gen-9-14-subseries-hero.png',
        'description': 'With its 11th Gen Intel Core processing, the ThinkPad X1 Carbon Gen 9 laptop is faster than ever no matter the task. Given it is Intel Evo certified, it delivers a super-responsive experience.',
        'specs': {
          'Processor': 'Intel Core i7-1185G7',
          'RAM': '16GB',
          'Storage': '512GB SSD',
          'Display': '14" UHD+'
        }
      },
      {
        'name': 'Asus ROG Zephyrus',
        'brand': 'Asus',
        'price': 1899.00,
        'rating': 4.6,
        'imageUrl': 'https://dlcdnwebimgs.asus.com/gain/2A0D3E3D-65E6-479A-8F12-07F6C5D66716',
        'description': 'World’s most powerful 14-inch gaming laptop. The result is a chassis that is just 1.79cm thin and 1.60kg light. Anime Matrix LED display on lid.',
        'specs': {
          'Processor': 'AMD Ryzen 9 5900HS',
          'RAM': '32GB',
          'Storage': '1TB NVMe',
          'Display': '14" 144Hz'
        }
      },
    ];

    // Upload loop
    for (var product in sampleProducts) {
      await productsRef.add(product);
      print('Added ${product['name']}');
    }
  }
}