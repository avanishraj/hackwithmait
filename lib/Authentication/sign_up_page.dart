import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackwithinfy/Authentication/customBropdownFormField.dart';
import 'package:hackwithinfy/Authentication/customTextFormField.dart';
import 'package:hackwithinfy/Authentication/login_page.dart';
import 'package:hackwithinfy/Authentication/passwordField.dart';
import 'package:hackwithinfy/Onboarding_Questions/onboarding_pages.dart';
import 'package:hackwithinfy/constants/global_variables.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _signupformKey = GlobalKey<FormState>();

  String? _firstName;
  String? _lastName;
  String? _email;
  String? _contactNumber;
  String? _age;
  String? _gender;
  String? _emergencyContactName;
  String? _emergencyContactNum;
  String? _password;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _emergencyContactNameController =
  TextEditingController();
  TextEditingController _emergencyContactNumController =
  TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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

  void registration() async {
    if (_password != null &&
        _firstNameController.text != "" &&
        _lastNameController.text != "" &&
        _emailController.text != "" &&
        _contactNumberController.text != "" &&
        _ageController.text != "" &&
        _genderController.text != "" &&
        _emergencyContactNameController.text != "" &&
        _emergencyContactNumController.text != "") {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _email!, password: _password!);
       String uid = userCredential.user?.uid ?? '';

      // Store additional user info in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'firstName': _firstName!,
        'lastName': _lastName!,
        'email': _email!,
        'contactNumber': _contactNumber!,
        'age': _age!,
        'gender': _gender!,
        'emergencyContactName': _emergencyContactName!,
        'emergencyContactNum': _emergencyContactNum!,
        'isUserAnsweredOnboardingQuestions': isUserAnsweredOnboardingQuestions,
      });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Registered Successfully")));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>  OnboardingPage(index: 0,
      question: questions[0],
      userEmail: "avanishraj005@gmail.com",),
          )
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Color.fromARGB(255, 165, 251, 128),
              content: Text("Password is too weak")));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Color.fromARGB(255, 165, 251, 128),
              content: Text("account already in use")));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Registration',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _signupformKey,
          child: ListView(
            children: [
              SizedBox(height: 20),
              CustomTextFormField(
                label: "First Name",
                controller: _firstNameController,
                hintText: 'e.g., John',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                label: "Last Name",
                controller: _lastNameController,
                hintText: 'e.g., Doe',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
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
              Text(
                "Phone Number",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  setState(() {
                    _contactNumber = number.phoneNumber;
                    _contactNumberController.text = _contactNumber ?? '';
                  });
                },
                onInputValidated: (bool value) {
                  print(value);
                },
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: TextStyle(color: Colors.black),
                formatInput: false,
                keyboardType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                inputDecoration: InputDecoration(
                  hintText: '99999999',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey.shade500, width: 1.5),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                ),
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                label: "Age (in years)",
                controller: _ageController,
                hintText: 'e.g: 25',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              SizedBox(height: 20),
              CustomDropdownFormField(
                label: "Gender",
                controller: _genderController,
                items: ['Male', 'Female', 'Other'],
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                label: "Emergency Contact Name",
                controller: _emergencyContactNameController,
                hintText: 'Guardian name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter emergency contact name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                label: "Emergency Number",
                controller: _emergencyContactNumController,
                hintText: '+919999999999',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the emergency number';
                  }
                  return null;
                },
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
              PasswordField(
                label: "Confirm Password",
                controller: _confirmPasswordController,
                passwordVisible: _confirmPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    _confirmPasswordVisible = !_confirmPasswordVisible;
                  });
                },
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_signupformKey.currentState!.validate()) {
                    setState(() {
                      _firstName = _firstNameController.text;
                      _lastName = _lastNameController.text;
                      _email = _emailController.text;
                      _contactNumber = _contactNumberController.text;
                      _age = _ageController.text;
                      _gender = _genderController.text;
                      _emergencyContactName =
                          _emergencyContactNameController.text;
                      _emergencyContactNum =
                          _emergencyContactNumController.text;
                      _password = _passwordController.text;
                    });
                    registration();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 165, 251, 128),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  minimumSize: Size(double.infinity,
                      50), // double.infinity is the width and 50 is the height
                ),
                child: Text('Sign Up'),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                          'Already have an account?',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ]
          )
        ),
      ),
    );
  }
}