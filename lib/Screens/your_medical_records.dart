import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class YourMedicalRecordsPage extends StatefulWidget {
  const YourMedicalRecordsPage({Key? key}) : super(key: key);

  @override
  _YourMedicalRecordsPageState createState() => _YourMedicalRecordsPageState();
}

class _YourMedicalRecordsPageState extends State<YourMedicalRecordsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userEmail = "avanishraj005@gmail.com";
  String? apiResponse;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchMedicalRecords();
  }

  Future<void> _fetchMedicalRecords() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      final snapshot =
          await _firestore.collection('userReportsData').doc(userEmail).get();

      if (!snapshot.exists) {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage = 'No medical records found for this user.';
        });
        return;
      }

      final data = snapshot.data();
      if (data == null) return;

      final List<dynamic> analysisList = data['analysisList'] ?? [];
      final responseSnapshot = await _firestore
          .collection('userReportDataResponses')
          .doc(userEmail)
          .get();

      if (responseSnapshot.exists) {
        final responseData = responseSnapshot.data() as Map<String, dynamic>?;
        if (responseData != null) {
          setState(() {
            apiResponse = responseData['response'];
            isLoading = false;
          });
        }
      } else {
        await _callMedicalHistoryAPI(analysisList);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage =
            'Failed to fetch medical records. Please try again later.';
      });
      print('Error fetching medical records: $e');
    }
  }

  Future<void> _callMedicalHistoryAPI(List<dynamic> analysisList) async {
    try {
      final items = analysisList
          .map((item) => AnalysisItem(
                LLM_output: item['LLM_output'],
                language: item['language'],
                message: item['message'],
              ))
          .toList();

      final response = await analyzeMedicalHistory(userEmail, items);

      if (response != null) {
        await _firestore
            .collection('userReportDataResponses')
            .doc(userEmail)
            .set({
          'response': response,
          'isDataFetched': true,
        });

        setState(() {
          apiResponse = response;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to analyze medical history');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage =
            'Failed to analyze medical history. Please try again later.';
      });
      print('Error analyzing medical history: $e');
    }
  }

  Future<String?> analyzeMedicalHistory(
      String email, List<AnalysisItem> analysisList) async {
    final String apiUrl = 'http://54.210.83.2:8000/analyze-medical-history';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'analysisList': analysisList.map((item) => item.toJson()).toList(),
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['medical_history_report'];
      }
      throw Exception('Failed to analyze medical history');
    } catch (e) {
      print('API call failed: $e');
      return null;
    }
  }

  Widget _buildLoadingState() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchMedicalRecords,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF14B8A6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalRecord() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF14B8A6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.medical_information,
                          color: Color(0xFF14B8A6),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Medical History Report',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    apiResponse ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF14B8A6),
        title: const Text(
          'Medical Records',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchMedicalRecords,
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? _buildLoadingState()
            : hasError
                ? _buildErrorState()
                : _buildMedicalRecord(),
      ),
    );
  }
}

class AnalysisItem {
  final String LLM_output;
  final String language;
  final String message;

  AnalysisItem({
    required this.LLM_output,
    required this.language,
    required this.message,
  });

  Map<String, dynamic> toJson() => {
        'LLM_output': LLM_output,
        'language': language,
        'message': message,
      };
}
