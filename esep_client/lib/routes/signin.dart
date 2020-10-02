import 'package:esep_client/partials/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../partials/custom_textfield.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email;
  String password;
  String formValidationStatus;

  IconData _emailValidationStatus;
  IconData _passwordValidationStatus;

  final RoundedLoadingButtonController loginButtonController = RoundedLoadingButtonController();

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

  void displayErrorStatus() {
    loginButtonController.error();
    Future.delayed(const Duration(seconds: 2), () => loginButtonController.stop());
  }

  void onLogin() {
    if (_emailValidationStatus == null) {
      setState(() => formValidationStatus = 'Invalid Email');
      return displayErrorStatus();
    } else if (_passwordValidationStatus == null) {
      setState(() => formValidationStatus = 'Invalid Password');
      return displayErrorStatus();
    } else if (_emailValidationStatus == Icons.check && _passwordValidationStatus == Icons.check) {
      Future.delayed(const Duration(seconds: 1), () async {
        try {
          userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
          setState(() => formValidationStatus = 'Success');
          return loginButtonController.success();
        } on FirebaseAuthException catch (error) {
          if (error.code == 'user-not-found') {
            setState(() => formValidationStatus = 'No user found for that email');
            return displayErrorStatus();
          } else if (error.code == 'wrong-password') {
            setState(() => formValidationStatus = 'Wrong password provided for that user');
            return displayErrorStatus();
          }
        } catch (e) {
          setState(() => formValidationStatus = e.toString());
          return displayErrorStatus();
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
        toolbarHeight: 90.0,
        title: Text(
          "XSEP Login",
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              Text(
                formValidationStatus ?? '',
                style: TextStyle(color: Colors.blueGrey),
              ),
              RoundedLoadingButton(
                controller: loginButtonController,
                child: Text('Login', style: TextStyle(color: Colors.white)),
                onPressed: onLogin,
              )
            ],
          ),
        ),
      ),
    );
  }
}
