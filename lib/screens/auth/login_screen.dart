import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login to LaptopHarbor')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (val) => email = val,
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (val) => password = val,
                validator: (val) => val!.length < 6 ? 'Enter 6+ chars' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Sign In'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    dynamic result = await _auth.signIn(email, password);
                    if (result != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result)));
                    }
                  }
                },
              ),
              TextButton(
                child: Text('Create Account'),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterScreen())),
              )
            ],
          ),
        ),
      ),
    );
  }
}