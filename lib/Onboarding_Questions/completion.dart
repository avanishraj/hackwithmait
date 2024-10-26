import 'package:flutter/material.dart';

class CompletionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Onboarding Complete"),
      ),
      body: Center(
        child: Text(
          "Thank you for completing the onboarding!",
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
