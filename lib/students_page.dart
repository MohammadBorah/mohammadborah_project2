import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentsPage extends StatefulWidget {
  @override
  _StudentsPageState createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  late Future<String> students;

  @override
  void initState() {
    super.initState();
    students = fetchStudents();
  }

  Future<String> fetchStudents() async {
    final url = 'https://profitech.000webhostapp.com/disply.php';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.body.trim(); // Trim removes leading/trailing whitespaces
    } else {
      return 'Error fetching students';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: students,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final data = snapshot.data!.split('\n');
              if (data.isNotEmpty && data[0] != 'No students found') {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data.map((studentInfo) {
                    final studentDetails = studentInfo.split(',');
                    if (studentDetails.length >= 4) {
                      return Text('ID: ${studentDetails[0]} - Name: ${studentDetails[1]} - ID Number: ${studentDetails[2]} - Course: ${studentDetails[3]}');
                    } else {
                      return Text('Invalid student information');
                    }
                  }).toList(),
                );
              } else {
                return Text('No students found');
              }
            }
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StudentsPage(),
  ));
}
