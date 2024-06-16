import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notedown/utility.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController _email = TextEditingController();
  // String message = "";

  reset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _email.text.trim());
    } on FirebaseAuthException catch (e) {
      MySnackbar.show(message: e.code);
    } catch (e) {
      MySnackbar.show(message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(brightness: Brightness.light),
        child: Scaffold(
          backgroundColor: Colors.blue,
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/app_logo.jpeg'),
                      radius: 50,
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Forgot Password",
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _email.clear();
                          },
                        ),
                        filled: true,
                        fillColor: Colors.grey[300],
                        hintText: 'Enter your email',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    ElevatedButton(
                      child: Text(
                        "Send mail",
                        style: TextStyle(fontSize: 22, color: Colors.blue),
                      ),
                      style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.fromLTRB(20, 10, 20, 10)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white)),
                      onPressed: () {
                        if (_email.text.trim() == "") {
                          MySnackbar.show(
                              message: "Please enter your email",
                              title: "Enter email");
                        } else if (!_email.text.contains("@")) {
                          MySnackbar.show(
                              message:
                                  "The email address you have provided is invalid",
                              title: "Invalid email");
                        } else {
                          reset();
                          MySnackbar.show(
                              message:
                                  "A reset password link has been sent to your email.",
                              title: "Reset password mail sent");
                        }
                      },
                    ),
                    SizedBox(height: 25),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
