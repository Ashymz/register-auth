import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:register/home.dart';

class EnrollmentPage extends StatefulWidget {
  @override
  _EnrollmentPageState createState() => _EnrollmentPageState();
}

class _EnrollmentPageState extends State<EnrollmentPage> {
  String selectedLevel = '';
  List<String> courses = [];
  List<String> allCourses = ['GNS', 'ENT', 'VOS'];
  bool showVerificationDialog = false;
  String selectedCourse = '';

  void onLevelSelected(String? level) {
    if (level != null) {
      setState(() {
        selectedLevel = level;
        courses = allCourses;
        selectedCourse = '';
      });
    }
  }

  void onCourseSelected(String course) {
    setState(() {
      selectedCourse = course;
      showVerificationDialog = true;
    });
  }

  void verifyWithFingerprint() {
    setState(() {
      showVerificationDialog = false;
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification Succesfull')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        print('Authentication failed');
      }
    } on PlatformException catch (e) {
      print('Authentication error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enroll for Courses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DropdownButtonFormField<String>(
              hint: Text('Select Level'),
              value: selectedLevel.isEmpty ? null : selectedLevel,
              items: ['100L', '200L', '300L', '400L']
                  .map((level) => DropdownMenuItem<String>(
                        value: level,
                        child: Text(level),
                      ))
                  .toList(),
              onChanged: onLevelSelected,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              isExpanded: true,
            ),
            SizedBox(height: 10),
            if (selectedLevel.isNotEmpty) ...[
              Text('Select Course'),
              ...courses.map((course) => ListTile(
                    title: Text(course),
                    onTap: () => onCourseSelected(course),
                  )),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Selected Course',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: selectedCourse),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check, color: Colors.blueAccent),
        onPressed: () {
          if (showVerificationDialog) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Verify with Fingerprint'),
                  content: Text('Place your finger on the sensor to verify.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // verifyWithFingerprint();
                        authenticate();
                      },
                      child: Text('Verify'),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
