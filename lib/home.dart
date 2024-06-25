// lib/home_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = '';
  String registrationNumber = '';
  String gender = '';
  String dateOfBirth = '';
  String passportPhotoPath = '';
  File? _passportPhoto;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  _loadDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      registrationNumber = prefs.getString('registrationNumber') ?? '';
      gender = prefs.getString('gender') ?? '';
      dateOfBirth = prefs.getString('dateOfBirth') ?? '';
      passportPhotoPath = prefs.getString('passportPhoto') ?? '';
      if (passportPhotoPath.isNotEmpty) {
        _passportPhoto = File(passportPhotoPath);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name: $name'),
            Text('Registration Number: $registrationNumber'),
            Text('Gender: $gender'),
            Text('Date of Birth: $dateOfBirth'),
            SizedBox(height: 20),
            _passportPhoto == null
                ? Text('No passport photo available.')
                : Image.file(_passportPhoto!, height: 200),
          ],
        ),
      ),
    );
  }
}
