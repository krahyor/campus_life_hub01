import 'package:flutter/material.dart';
import 'dart:developer';

import 'auth_service.dart';
import 'signup_screen.dart';
import '../../screens/main_screen/main_screen.dart';
import '../../widgets/auth_widgets/button.dart';
import '../../widgets/auth_widgets/textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();

  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
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
                "Login to your Account",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ),

            const SizedBox(height: 15),
            CustomTextField(
              hint: "Enter Email",
              label: "Email",
              controller: _email,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: "Enter Password",
              label: "Password",
              controller: _password,
              isPassword: true,
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: "Sign in",
              onPressed: _login,
              bttncolor: Color.fromARGB(255, 52, 105, 154),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                InkWell(
                  onTap: () => goToSignup(context),
                  child: const Text(
                    "Signup",
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

  goToSignup(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SignupScreen()),
  );

  goToMainHomeScreen(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MainHomeScreen()),
  );

  _login() async {
    final user = await _auth.loginUserWithEmailAndPassword(
      _email.text,
      _password.text,
    );

    if (user != null) {
      log("User Logged In");
      goToMainHomeScreen(context);
    }
  }
}
