// lib/register_page.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:register/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:image_picker/image_picker.dart';

// class RegisterPage extends StatefulWidget {
//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final _formKey = GlobalKey<FormState>();
//    String name, registrationNumber, gender, dateOfBirth;

//   late File _passportPhoto;
//   final ImagePicker _picker = ImagePicker();
//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       if (pickedFile != null) {
//         _passportPhoto = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   final LocalAuthentication _authService = LocalAuthentication();
//   bool _isAuthenticated = false;

//   late final LocalAuthentication auth;
//   bool _supportState = false;

//   @override
//   void initState() {
//     super.initState();
//     auth = LocalAuthentication();
//     auth.isDeviceSupported().then(
//       (bool isSupported) {
//         setState(() {
//           _supportState = isSupported;
//         });
//       },
//     );
//   }

//   Future<void> authenticate() async {
//     try {
//       bool authenticated = await auth.authenticate(
//         localizedReason: 'Authenticate to Login',
//         options: const AuthenticationOptions(
//           stickyAuth: true,
//           biometricOnly: true,
//         ),
//       );

//       if (authenticated) {
//         if (_formKey.currentState!.validate() && _passportPhoto != null) {
//           _formKey.currentState!.save();
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           prefs.setString('name', name);
//           prefs.setString('registrationNumber', registrationNumber);
//           prefs.setString('gender', gender);
//           prefs.setString('dateOfBirth', dateOfBirth);
//           prefs.setString('passportPhoto', _passportPhoto.path);

//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => LoginPage()),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content:
//                     Text('Please fill all fields and select a passport photo')),
//           );
//         }
//       } else {
//         print('Authentication failed');
//       }
//     } on PlatformException catch (e) {
//       print('Authentication error: $e');
//     }
//   }

//   _saveDetails() async {
//     if (_formKey.currentState!.validate() && _passportPhoto != null) {
//       _formKey.currentState!.save();
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setString('name', name);
//       prefs.setString('registrationNumber', registrationNumber);
//       prefs.setString('gender', gender);
//       prefs.setString('dateOfBirth', dateOfBirth);
//       prefs.setString('passportPhoto', _passportPhoto.path);

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginPage()),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content:
//                 Text('Please fill all fields and select a passport photo')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Register'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: ListView(
//             children: <Widget>[
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Name'),
//                 validator: (value) =>
//                     value!.isEmpty ? 'Please enter your name' : null,
//                 onSaved: (value) => name = value!,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Registration Number'),
//                 validator: (value) => value!.isEmpty
//                     ? 'Please enter your registration number'
//                     : null,
//                 onSaved: (value) => registrationNumber = value!,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Gender'),
//                 validator: (value) =>
//                     value!.isEmpty ? 'Please enter your gender' : null,
//                 onSaved: (value) => gender = value!,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Date of Birth'),
//                 validator: (value) =>
//                     value!.isEmpty ? 'Please enter your date of birth' : null,
//                 onSaved: (value) => dateOfBirth = value!,
//               ),
//               SizedBox(height: 20),
//               _passportPhoto == null
//                   ? Text('No image selected.')
//                   : Image.file(_passportPhoto, height: 200),
//               ElevatedButton(
//                 onPressed: _pickImage,
//                 child: Text('Select Passport Photo'),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _saveDetails,
//                 child: Text('Register'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// lib/register_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String registrationNumber = '';
  String gender = '';
  String dateOfBirth = '';
  File? _passportPhoto;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _passportPhoto = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  final LocalAuthentication _authService = LocalAuthentication();
  bool _isAuthenticated = false;

  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
      (bool isSupported) {
        setState(() {
          _supportState = isSupported;
        });
      },
    );
  }

  Future<void> authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to Register',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        _saveDetails();
      } else {
        print('Authentication failed');
      }
    } on PlatformException catch (e) {
      print('Authentication error: $e');
    }
  }

  _saveDetails() async {
    if (_formKey.currentState!.validate() && _passportPhoto != null) {
      _formKey.currentState!.save();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('name', name);
      prefs.setString('registrationNumber', registrationNumber);
      prefs.setString('gender', gender);
      prefs.setString('dateOfBirth', dateOfBirth);
      prefs.setString('passportPhoto', _passportPhoto!.path);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Please fill all fields and select a passport photo')),
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
              TextFormField(
                decoration: InputDecoration(labelText: 'Gender'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your gender' : null,
                onSaved: (value) => gender = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date of Birth'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your date of birth' : null,
                onSaved: (value) => dateOfBirth = value!,
              ),
              SizedBox(height: 20),
              _passportPhoto == null
                  ? Text('No image selected.')
                  : Image.file(_passportPhoto!, height: 200),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Select Passport Photo'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveDetails,
                child: Text('Register'),
              ),
              ElevatedButton(
                onPressed: authenticate,
                child: Text('Register with Fingerprint'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
