import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notedown/pages/signup.dart';
import 'package:notedown/pages/forgotpassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notedown/utility.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  // String message = "";
  bool hidepass1 = true;
  bool loading = false;

  signin() async {
    setState(() {
      loading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text.trim(), password: _pass.text);
    } on FirebaseAuthException catch (e) {
      String error_title = "Error message";
      String error_message = e.code;
      if (error_message == 'invalid-credential') {
        error_message = "Invalid email or password.";
        error_title = "Invalid credentials";
      } else if (error_message == 'network-request-failed') {
        error_title = "Network error";
        error_message = "Please ensure you have an active internet connection";
      }
      MySnackbar.show(title: error_title, message: error_message);
    } catch (e) {
      MySnackbar.show(message: e.toString());
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(brightness: Brightness.light),
        child: loading
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Signing In",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold))
                ],
              ))
            : Scaffold(
                backgroundColor: Colors.blue,
                body: Center(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/app_logo.jpeg'),
                              radius: 50,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Log in",
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
                              controller: _pass,
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
                                hintText: 'Enter Password',
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              obscureText: hidepass1,
                            ),
                            SizedBox(height: 10),
                            TextButton(
                                onPressed: () {
                                  Get.to(ForgotPasswordPage());
                                },
                                child: Text(
                                  "Forgot password",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                )),
                            SizedBox(height: 35),
                            ElevatedButton(
                              child: Text(
                                "Log in",
                                style:
                                    TextStyle(fontSize: 22, color: Colors.blue),
                              ),
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                      EdgeInsets.fromLTRB(20, 10, 20, 10)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white)),
                              onPressed: () {
                                if (_email.text.trim() == "" ||
                                    _pass.text.trim() == "") {
                                  MySnackbar.show(
                                      title: "Note",
                                      message: "Contents cannot be empty.");
                                } else {
                                  signin();
                                }
                              },
                            ),
                            SizedBox(height: 35),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.yellowAccent),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.to(SignupPage());
                                  },
                                  child: Text("Sign up"),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(EdgeInsets.all(1)),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ));
  }
}
