// lib/home_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String name, registrationNumber, gender, dateOfBirth;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  _loadDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
      registrationNumber = prefs.getString('registrationNumber')!;
      gender = prefs.getString('gender')!;
      dateOfBirth = prefs.getString('dateOfBirth')!;
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
            // Display passport photo if necessary
          ],
        ),
      ),
    );
  }
}
