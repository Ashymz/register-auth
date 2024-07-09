// lib/home_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:register/auth/register.dart';
import 'package:register/quiz.dart';
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

  void clearLocalStorageAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.red,
            ),
            onPressed: () async {
              clearLocalStorageAndNavigate();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Name: $name',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text('Registration Number: $registrationNumber',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  Text('Gender: $gender',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  Text('Date of Birth: $dateOfBirth',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  SizedBox(height: 20),
                  _passportPhoto == null
                      ? Text('No passport photo available.')
                      : Image.file(_passportPhoto!, height: 200),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.quiz, color: Colors.blueAccent),
          onPressed: () async {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => QuizPage()),
            );
          }),
    );
  }
}
