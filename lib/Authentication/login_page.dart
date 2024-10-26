import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackwithinfy/Authentication/customTextFormField.dart';
import 'package:hackwithinfy/Authentication/passwordField.dart';
import 'package:hackwithinfy/Authentication/sign_up_page.dart';
import 'package:hackwithinfy/Screens/body.dart';
import 'package:hackwithinfy/Screens/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginformKey = GlobalKey<FormState>();

  String? _email;
  String? _password;
  bool _passwordVisible = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void login() async {
    if (_email != null && _password != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email!, password: _password!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text("No User Found for that Email")));
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text("Wrong Password Provided by User")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text("Error: ${e.message}")));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("An unknown error occurred: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Login',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _loginformKey,
          child: ListView(
            children: [
              SizedBox(height: 20),
              CustomTextFormField(
                label: "Email Address",
                controller: _emailController,
                hintText: 'e.g., john.doe@example.com',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              PasswordField(
                label: "Password",
                controller: _passwordController,
                passwordVisible: _passwordVisible,
                toggleVisibility: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Implement the logic of forgot password
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_loginformKey.currentState!.validate()) {
                    setState(() {
                      _email = _emailController.text;
                      _password = _passwordController.text;
                    });
                    login();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 165, 251, 128),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Login'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Do not have an account?',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}