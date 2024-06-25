// lib/login_page.dart
import 'package:flutter/material.dart';
import 'package:register/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String name, registrationNumber;

  _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedName = prefs.getString('name');
      String? savedRegNum = prefs.getString('registrationNumber');

      if (name == savedName && registrationNumber == savedRegNum) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid credentials')),
        );
      }
    }
  }

  // Add a method for fingerprint authentication

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Registration Number'),
                validator: (value) => value!.isEmpty
                    ? 'Please enter your registration number'
                    : null,
                onSaved: (value) => registrationNumber = value!,
              ),
              // Add a widget/button for fingerprint authentication
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
