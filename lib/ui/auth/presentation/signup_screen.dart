import 'dart:developer';

import 'auth_service.dart';
import 'login_screen.dart';
import '../../widgets/auth_widgets/button.dart';
import '../../widgets/auth_widgets/textfield.dart';

import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = AuthService();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            // const Spacer(),
            const SizedBox(height: 200),
            const Text(
              "Campus Life Hub",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 17, 63, 103),
              ),
            ),
            const SizedBox(height: 120),
            Align(
              alignment: Alignment.centerLeft, // Align text to the left
              child: const Text(
                "Create your Account",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 15),
            CustomTextField(
              hint: "Enter Name",
              label: "Name",
              controller: _name,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: "Enter Email",
              label: "Email",
              controller: _email,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: "Enter Password",
              label: "Password",
              isPassword: true,
              controller: _password,
            ),
            const SizedBox(height: 30),
            CustomButton(
              label: "Sign up",
              onPressed: _signup,
              bttncolor: Color.fromARGB(255, 52, 105, 154),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                InkWell(
                  onTap: () => goToLogin(context),
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );

  _signup() async {
    final user = await _auth.createUserWithEmailAndPassword(
      _email.text,
      _password.text,
    );
    if (user != null) {
      log("User Created Successfully");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup successful. Please login.')),
      );

      goToLogin(context);
    }
  }
}
