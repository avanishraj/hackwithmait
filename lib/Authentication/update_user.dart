import 'package:flutter/material.dart';
import 'package:hackwithinfy/Authentication/update_repo.dart';

class UpdateUserPage extends StatelessWidget {
  final String email = "user@example.com"; // Replace with the actual user email
  final UserRepository userRepository = UserRepository();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController emergencyContactNameController = TextEditingController();
  final TextEditingController emergencyContactNumController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update User Info")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: contactNumberController,
              decoration: InputDecoration(labelText: "Contact Number"),
            ),
            TextField(
              controller: emergencyContactNameController,
              decoration: InputDecoration(labelText: "Emergency Contact Name"),
            ),
            TextField(
              controller: emergencyContactNumController,
              decoration: InputDecoration(labelText: "Emergency Contact Number"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Update the contact number using email
                await userRepository.updateUserFieldByEmail(email, 'contactNumber', contactNumberController.text);
                
                // Update the emergency contact information using email
                await userRepository.updateUserFieldByEmail(
                  email,
                  'emergencyContactName',
                  emergencyContactNameController.text,
                );
                await userRepository.updateUserFieldByEmail(
                  email,
                  'emergencyContactNum',
                  emergencyContactNumController.text,
                );

                // Optionally show a confirmation message
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User info updated")));
              },
              child: Text("Update Info"),
            ),
          ],
        ),
      ),
    );
  }
}
