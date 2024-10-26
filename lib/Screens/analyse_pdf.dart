import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'body.dart';

class ChatInterface extends StatefulWidget {
  @override
  _ChatInterfaceState createState() => _ChatInterfaceState();
}

class _ChatInterfaceState extends State<ChatInterface> {
  File? _selectedPDF;
  String? _selectedLanguage;
  bool _isLoading = false;

  final TextEditingController _textController = TextEditingController();

  Future<void> _pickPDF() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        _selectedPDF = File(result.files.single.path!);
      });
    }
  }

  Future<void> _sendPDFWithQuery() async {
    if (_selectedPDF == null || _selectedLanguage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a PDF and language first')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final uri = Uri.parse('http://54.210.83.2:8000/upload_pdf/');
    final request = http.MultipartRequest('POST', uri)
      ..fields['language'] = _selectedLanguage!
      ..fields['file_name'] =
          'report1' // Change to the actual file name if needed
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        _selectedPDF!.path,
        contentType: MediaType('application', 'pdf'),
      ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      print(_selectedLanguage);
      print(jsonResponse['LLM_output']);
      setState(() {
        _textController.text = jsonResponse['LLM_output'].toString();
      });
      await _storeResponseInFirestore(jsonResponse);
    } else {
      print('Failed to upload PDF: ${response.statusCode}');
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _storeResponseInFirestore(dynamic jsonResponse) async {
    final String userEmail = FirebaseAuth.instance.currentUser!.email
        .toString(); // Replace with the actual user's email

    try {
      final userDoc = FirebaseFirestore.instance
          .collection('userReportsData')
          .doc(userEmail);

      await userDoc.set(
        {
          'email': userEmail,
          'analysisList': FieldValue.arrayUnion(
              [jsonResponse]), // Append the new response to the list
        },
        SetOptions(
            merge: true), // Merge with existing document or create a new one
      );

      print("Response stored successfully.");
    } catch (e) {
      print("Error storing response: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildPDFUploadCard(),
                      const SizedBox(height: 16),
                      _buildLanguageSelectionCard(),
                      const SizedBox(height: 24),
                      _buildSubmitButton(),
                      const SizedBox(height: 24),
                      if (!_isLoading) _buildResponseCard(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF14B8A6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, top: 5),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back_ios,
                    size: 20, color: Color(0xFF14B8A6)),
              ),
            ),
            const SizedBox(width: 20),
            const Text(
              'Dr. Early Pulse',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPDFUploadCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upload Medical Report',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickPDF,
              icon: const Icon(Icons.upload_file),
              label: const Text('Choose PDF'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF14B8A6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
            if (_selectedPDF != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf, color: Color(0xFF14B8A6)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedPDF!.path.split('/').last,
                        style: TextStyle(color: Colors.grey[700]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF14B8A6)),
                      onPressed: () => setState(() => _selectedPDF = null),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelectionCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Language',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            ...['English', 'Hindi', 'Hinglish'].map(
              (language) => _buildLanguageOption(language),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _selectedLanguage == language
              ? const Color(0xFF14B8A6)
              : Colors.grey[300]!,
        ),
      ),
      child: RadioListTile<String>(
        title: Text(
          language,
          style: TextStyle(
            color: _selectedLanguage == language
                ? const Color(0xFF14B8A6)
                : Colors.grey[700],
          ),
        ),
        value: language,
        groupValue: _selectedLanguage,
        activeColor: const Color(0xFF14B8A6),
        onChanged: (value) => setState(() => _selectedLanguage = value),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    final bool isEnabled = _selectedPDF != null && _selectedLanguage != null;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled && !_isLoading ? _sendPDFWithQuery : null,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF14B8A6),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Submit',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  // Widget _buildResponseCard() {
  //   return Card(
  //     elevation: 2,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     child: Container(
  //       width: double.infinity,
  //       padding: const EdgeInsets.all(20),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const Text(
  //             'Response',
  //             style: TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.bold,
  //               color: Color(0xFF2D3748),
  //             ),
  //           ),
  //           const SizedBox(height: 16),
  //           Text(
  //             _textController.text.isEmpty
  //                 ? 'Response will be shown here'
  //                 : _textController.text,
  //             style: TextStyle(
  //               fontSize: 16,
  //               color: Colors.grey[700],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget _buildResponseCard() {
    return ResponseCard(
      textController: _textController,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class ResponseCard extends StatefulWidget {
  final TextEditingController textController;

  const ResponseCard({
    Key? key,
    required this.textController,
  }) : super(key: key);

  @override
  State<ResponseCard> createState() => _ResponseCardState();
}

class _ResponseCardState extends State<ResponseCard> {
  final FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    // Initialize TTS settings
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.5);
    flutterTts.setVolume(1.0);
    flutterTts.setPitch(1.0);

    // Listen for TTS completion
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
  }

  Future<void> _speak() async {
    if (widget.textController.text.isEmpty) return;

    if (isSpeaking) {
      await flutterTts.stop();
      setState(() {
        isSpeaking = false;
      });
    } else {
      setState(() {
        isSpeaking = true;
      });
      await flutterTts.speak(widget.textController.text);
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Response',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                IconButton(
                  onPressed: widget.textController.text.isEmpty ? null : _speak,
                  icon: Icon(
                    isSpeaking ? Icons.stop_circle : Icons.play_circle,
                    color: widget.textController.text.isEmpty
                        ? Colors.grey
                        : Colors.blue,
                    size: 28,
                  ),
                  tooltip: isSpeaking ? 'Stop speaking' : 'Listen to response',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.textController.text.isEmpty
                  ? 'Response will be shown here'
                  : widget.textController.text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
