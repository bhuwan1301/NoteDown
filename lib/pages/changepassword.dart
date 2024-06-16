import 'package:flutter/material.dart';
import 'package:notedown/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  String? email;

  reset() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      email = user.email;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email ?? '');
      MySnackbar.show(
          message: 'An email has been sent to your account to reset password',
          title: 'Password reset mail sent');
    } on FirebaseAuthException catch (e) {
      MySnackbar.show(message: e.code);
    } catch (e) {
      MySnackbar.show(message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Settings",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 15, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Change Password",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextButton(
                  onPressed: () {
                    reset();
                  },
                  child: Text("Click to send password reset mail"))
            ],
          ),
        ),
      ),
    );
  }
}
