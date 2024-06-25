// lib/register_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String name, registrationNumber, gender, dateOfBirth;

  _saveDetails() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('name', name);
      prefs.setString('registrationNumber', registrationNumber);
      prefs.setString('gender', gender);
      prefs.setString('dateOfBirth', dateOfBirth);
      // Save passport photo if necessary

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value.isEmpty ? 'Please enter your name' : null,
                onSaved: (value) => name = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Registration Number'),
                validator: (value) => value.isEmpty ? 'Please enter your registration number' : null,
                onSaved: (value) => registrationNumber = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Gender'),
                validator: (value) => value!.isEmpty ? 'Please enter your gender' : null,
                onSaved: (value) => gender = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date of Birth'),
                validator: (value) => value.isEmpty ? 'Please enter your date of birth' : null,
                onSaved: (value) => dateOfBirth = value!,
              ),
              // Add a widget for passport photo if necessary
              // Add a widget/button for fingerprint authentication
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveDetails,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
