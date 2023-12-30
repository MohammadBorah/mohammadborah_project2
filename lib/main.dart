import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance System',
      home: const AttendanceForm(),
    );
  }
}

class AttendanceForm extends StatefulWidget {
  const AttendanceForm({Key? key}) : super(key: key);

  @override
  _AttendanceFormState createState() => _AttendanceFormState();
}

class _AttendanceFormState extends State<AttendanceForm> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerID = TextEditingController();
  final TextEditingController _controllerClass = TextEditingController();
  bool _loading = false;

  void submitAttendance() async {
    setState(() {
      _loading = true;
    });

    final String name = _controllerName.text;
    final String id = _controllerID.text;
    final String className = _controllerClass.text;

    if (name.isEmpty || id.isEmpty || className.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all fields.'),
        ),
      );
      setState(() {
        _loading = false;
      });
      return;
    }
//id19881852_mohammad
    //Mo@12345 password
    final Map<String, dynamic> attendanceData = {
      'name': name,
      'id': id,
      'class': className,
    };

    final Uri apiUrl = Uri.parse('https://profitech.000webhostapp.com/attendance.php');


    try {
      final http.Response response = await http.post(
        apiUrl,
        body: jsonEncode(attendanceData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Attendance submitted successfully!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit attendance. Status code: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance System'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16.0),
            TextField(
              controller: _controllerName,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _controllerID,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'ID'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _controllerClass,
              decoration: const InputDecoration(labelText: 'Class'),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _loading ? null : submitAttendance,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Submit Attendance'),
            ),

          ],
        ),
      ),
    );
  }
}
