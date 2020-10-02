import 'package:esep_client/partials/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../partials/custom_textfield.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email;
  String password;
  String formValidationStatus;

  IconData _emailValidationStatus;
  IconData _passwordValidationStatus;
  IconData _confirmPasswordValidationStatus;

  final RoundedLoadingButtonController registerButtonController = RoundedLoadingButtonController();

  void onEmailChanged(String value) {
    setState(() {
      formValidationStatus = "";
      if (emailRegex.hasMatch(value)) {
        _emailValidationStatus = Icons.check;
        email = value;
      } else
        _emailValidationStatus = null;
    });
  }

  void onPasswordChanged(String value) {
    setState(() {
      formValidationStatus = "";
      if (passwordRegex.hasMatch(value)) {
        _passwordValidationStatus = Icons.check;
        password = value;
      } else
        _passwordValidationStatus = null;
    });
  }

  void onConfirmPasswordChanged(String value) {
    setState(() {
      if (password == value) {
        _confirmPasswordValidationStatus = Icons.check;
      } else
        _confirmPasswordValidationStatus = null;
    });
  }

  void displayErrorStatus() {
    registerButtonController.error();
    Future.delayed(const Duration(seconds: 2), () => registerButtonController.stop());
  }

  void onRegister() {
    if (_emailValidationStatus == null) {
      setState(() => formValidationStatus = 'Invalid Email');
      return displayErrorStatus();
    } else if (_passwordValidationStatus == null) {
      setState(() => formValidationStatus = 'Invalid Password');
      return displayErrorStatus();
    } else if (_confirmPasswordValidationStatus == null) {
      setState(() => formValidationStatus = 'Confirm your password again!');
      return displayErrorStatus();
    } else if (_emailValidationStatus == Icons.check &&
        _passwordValidationStatus == Icons.check &&
        _confirmPasswordValidationStatus == Icons.check) {
      Future.delayed(const Duration(seconds: 1), () async {
        try {
          userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
          setState(() => formValidationStatus = 'Registered');
          return registerButtonController.success();
        } on FirebaseAuthException catch (error) {
          if (error.code == 'weak-password') {
            setState(() => formValidationStatus = 'The password provided is too weak');
            return displayErrorStatus();
          } else if (error.code == 'email-already-in-use') {
            setState(() => formValidationStatus = 'The account already exists for that email');
            return displayErrorStatus();
          }
        }
      });
    } else {
      setState(() => formValidationStatus = 'Something went wrong!');
      return displayErrorStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 90.0,
        title: Text(
          "Sign Up",
          style: const TextStyle(
            fontSize: 30.0,
            color: Colors.blueGrey,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 70, 50, 90),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              XSEPTextField(
                hintText: 'Enter your email',
                obscureText: false,
                prefixIconData: Icons.mail_outline,
                suffixIconData: _emailValidationStatus,
                onChanged: onEmailChanged,
                keyboardType: TextInputType.emailAddress,
                autofillHints: [AutofillHints.email],
              ),
              XSEPTextField(
                hintText: 'Enter your password',
                obscureText: true,
                prefixIconData: Icons.lock,
                suffixIconData: _passwordValidationStatus,
                onChanged: onPasswordChanged,
                autofillHints: [AutofillHints.password],
              ),
              XSEPTextField(
                hintText: 'Confirm your password',
                obscureText: true,
                prefixIconData: Icons.confirmation_number,
                suffixIconData: _confirmPasswordValidationStatus,
                onChanged: onConfirmPasswordChanged,
                autofillHints: [AutofillHints.password],
              ),
              const Text(
                '''Password should contain -\n
  ◼ At least one upper case.
  ◼ At least one lower case.
  ◼ At least one digit.
  ◼ At least one special character.
''',
                style: TextStyle(color: Colors.blueGrey),
              ),
              Text(
                formValidationStatus ?? '',
                style: TextStyle(color: Colors.blueGrey),
              ),
              RoundedLoadingButton(
                controller: registerButtonController,
                child: Text('Register', style: TextStyle(color: Colors.white)),
                onPressed: onRegister,
              )
            ],
          ),
        ),
      ),
    );
  }
}
