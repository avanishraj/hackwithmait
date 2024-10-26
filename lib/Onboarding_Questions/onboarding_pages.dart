import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Screens/body.dart';

class OnboardingPage extends StatelessWidget {
  final int index;
  final String question;
  final String userEmail;
  List<Map<String, dynamic>> responses = [];
  final TextEditingController responseController = TextEditingController();

  final List<String> questions = [
    "How would you rate your overall health?",
    "How often do you engage in physical activity or exercise?",
    "Do you have any existing medical conditions (e.g., diabetes, hypertension, asthma)?",
    "What is your age group?",
    "How many hours of sleep do you typically get per night?",
    "How often do you feel stressed or anxious?",
    "Do you consume any intoxicants substances?",
    "How often do you get a health checkup?",
    "How many times a day do you typically eat meals (including snacks)?",
    "Is there anything you want to share about your health condition?",
  ];

  OnboardingPage({required this.index, required this.question, required this.userEmail});

  Future<void> sendInsightsRequest(List<Map<String, dynamic>> queries) async {
    final uri = Uri.parse('http://44.210.116.15:8000/get-insights');
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({'query': queries});

    try {
      final response = await http.post(uri, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Response: ${response.body}');
      } else {
        print('Failed to get insights. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _storeResponse(BuildContext context) async {
    final String response = responseController.text;
    if (response.isNotEmpty) {
      responses.add({
        'index': index,
        'question': question,
        'response': response,
      });

      DocumentReference userDoc = FirebaseFirestore.instance.collection('onboardingResponses').doc(userEmail);

      try {
        DocumentSnapshot docSnapshot = await userDoc.get();

        if (docSnapshot.exists) {
          await userDoc.update({
            'responses': FieldValue.arrayUnion([{
              'index': index,
              'question': question,
              'response': response,
            }])
          });
        } else {
          await userDoc.set({
            'email': userEmail,
            'responses': [{
              'index': index,
              'question': question,
              'response': response,
            }]
          });
        }

        if (index < questions.length - 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OnboardingPage(
                index: index + 1,
                question: questions[index + 1],
                userEmail: userEmail,
              ),
            ),
          );
        } else {
          print(responses);
          // await sendInsightsRequest(responses);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
          );
        }
      } catch (e) {
        print("Failed to store response: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Onboarding", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff14B8A6),
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text(
                "Question ${index + 1}/${questions.length}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                question,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: responseController,
                decoration: InputDecoration(
                  labelText: "Your response",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xff14B8A6), width: 2),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _storeResponse(context),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Color(0xff14B8A6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
