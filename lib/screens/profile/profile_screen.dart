import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/database_service.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.person, size: 50),
              title: Text(user?.email ?? 'Guest'),
              subtitle: Text('UID: ${user?.uid}'),
            ),
            Divider(),
            Text('Order History', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: DatabaseService().getUserOrders(user!.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                if (snapshot.data!.docs.isEmpty) return Text('No orders yet.');

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index];
                    return Card(
                      child: ListTile(
                        title: Text('Order Amount: \$${data['amount']}'),
                        subtitle: Text('Date: ${data['date'].toString().substring(0, 10)}'),
                        trailing: Chip(
                          label: Text(data['status']),
                          backgroundColor: Colors.orange[100],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}