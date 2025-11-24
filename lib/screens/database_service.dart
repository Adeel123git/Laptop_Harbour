import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get Products Stream
  Stream<List<Product>> get products {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Add Order
  Future<void> placeOrder(String userId, Map<String, dynamic> orderData) async {
    await _db.collection('orders').add(orderData);
  }

  // Get User Orders
  Stream<QuerySnapshot> getUserOrders(String userId) {
    return _db.collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots();
  }

  // Toggle Wishlist
  Future<void> toggleWishlist(String userId, String productId) async {
    final userRef = _db.collection('users').doc(userId);
    final doc = await userRef.get();
    List wishlist = doc.data()?['wishlist'] ?? [];

    if (wishlist.contains(productId)) {
      userRef.update({'wishlist': FieldValue.arrayRemove([productId])});
    } else {
      userRef.update({'wishlist': FieldValue.arrayUnion([productId])});
    }
  }
}