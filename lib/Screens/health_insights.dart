import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class DailyRoutinePage extends StatefulWidget {
  final String userEmail;

  DailyRoutinePage({required this.userEmail});

  @override
  _DailyRoutinePageState createState() => _DailyRoutinePageState();
}

class _DailyRoutinePageState extends State<DailyRoutinePage> {
  String routineReport = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchAndGenerateReport();
  }

  // Function to fetch onboarding responses from Firestore
  Future<Map<String, dynamic>> fetchOnboardingResponses(
      String userEmail) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('onboardingResponses')
          .doc(userEmail)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        throw Exception("No responses found for this user.");
      }
    } catch (e) {
      print("Error fetching data: $e");
      throw Exception("Error fetching onboarding responses.");
    }
  }

  // Function to send data to FastAPI and get the routine report
  Future<String> generateRoutineReport(Map<String, dynamic> userData) async {
    const String apiUrl = "http://54.210.83.2:8000/generate-daily-routine";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['daily_routine_report'];
      } else {
        throw Exception("Failed to generate report");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Failed to communicate with the backend.");
    }
  }

  // Function to fetch and generate the routine report
  void fetchAndGenerateReport() async {
    try {
      Map<String, dynamic> responses =
          await fetchOnboardingResponses(widget.userEmail);
      String report = await generateRoutineReport(responses);
      setState(() {
        routineReport = report;
      });
    } catch (e) {
      setState(() {
        routineReport = "Failed to generate report.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Routine Report"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Daily Routine",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 10),
                  Text(
                    routineReport,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
