import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notedown/wrapper.dart';
import 'package:notedown/utility.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _pass1 = TextEditingController();
  TextEditingController _pass2 = TextEditingController();
  bool hidepass1 = true;
  bool hidepass2 = true;

  signup() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text.trim(), password: _pass1.text);
      Get.offAll(Wrapper());
    } on FirebaseAuthException catch (e) {
      String error_title = "Error message";
      String error_message = e.code;
      if (error_message == 'email-already-in-use') {
        error_message = "The email has already been registered with an account";
        error_title = "Email in use";
      } else if (error_message == 'network-request-failed') {
        error_title = "Network error";
        error_message = "Please ensure you have an active internet connection";
      }
      MySnackbar.show(message: error_message, title: error_title);
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
                    SizedBox(height: 10),
                    Text(
                      "Sign Up",
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
                    SizedBox(height: 30),
                    TextField(
                      controller: _pass1,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            setState(() {
                              hidepass1 = !hidepass1;
                            });
                            ;
                          },
                        ),
                        filled: true,
                        fillColor: Colors.grey[300],
                        hintText: 'Create Password',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      obscureText: hidepass1,
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: _pass2,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            setState(() {
                              hidepass2 = !hidepass2;
                            });
                            ;
                          },
                        ),
                        filled: true,
                        fillColor: Colors.grey[300],
                        hintText: 'Confirm Password',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      obscureText: hidepass2,
                    ),
                    SizedBox(height: 50),
                    ElevatedButton(
                      child: Text(
                        "Sign up",
                        style: TextStyle(fontSize: 22, color: Colors.blue),
                      ),
                      style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.fromLTRB(20, 10, 20, 10)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white)),
                      onPressed: () {
                        if (_email.text.trim() == "" ||
                            _pass1.text.trim() == "" ||
                            _pass2.text.trim() == "") {
                          MySnackbar.show(
                              message: "Contents cannot be empty!",
                              title: "Note");
                        } else if (_pass1.text.contains(' ') ||
                            _pass2.text.contains(' ')) {
                          MySnackbar.show(
                              message: "Password cannot contain blank spaces",
                              title: "Note");
                        } else if (_pass1.text != _pass2.text) {
                          MySnackbar.show(
                              message:
                                  "Please ensure you have entered the same password in both fields.",
                              title: "Password Mismatch");
                        } else if (!_email.text.contains("@")) {
                          MySnackbar.show(
                              title: "Invalid email",
                              message:
                                  "Them email address you have provided is invalid");
                        } else {
                          signup();
                          MySnackbar.show(
                              message:
                                  "Please wait while we create your account.",
                              title: "Signing up");
                        }
                      },
                    ),
                    SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
