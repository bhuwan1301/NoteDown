import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:notedown/wrapper.dart';
import 'package:notedown/pages/home.dart';
import 'package:notedown/utility.dart';

class VerifymailPage extends StatefulWidget {
  const VerifymailPage({super.key});

  @override
  State<VerifymailPage> createState() => _VerifymailPageState();
}

class _VerifymailPageState extends State<VerifymailPage> {
  bool verified = false;

  signout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(Wrapper());
    } on FirebaseAuthException catch (e) {
      MySnackbar.show(message: e.code);
    } catch (e) {
      MySnackbar.show(message: e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    verified = FirebaseAuth.instance.currentUser!.emailVerified;
    try {
      if (!verified) {
        sendVerificationMail();
      }
    } on FirebaseAuthException catch (e) {
      MySnackbar.show(message: e.code);
    } catch (e) {
      MySnackbar.show(message: e.toString());
    }
  }

  Future sendVerificationMail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      MySnackbar.show(message: e.code, duration: Duration(seconds: 2));
    } catch (e) {
      MySnackbar.show(message: e.toString(), duration: Duration(seconds: 2));
    }
  }

  reload() async {
    await FirebaseAuth.instance.currentUser!
        .reload()
        .then((value) => {Get.offAll(Wrapper())});
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(brightness: Brightness.light),
        child: verified
            ? Home()
            : Scaffold(
                backgroundColor: Colors.blue,
                body: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Verify email",
                            style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "A link to verify email has been sent to your email address. \nPlease click on it to verify your account. Click on reload once verified.",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          SizedBox(height: 20),
                          TextButton(
                              onPressed: () {
                                signout();
                                Get.offAll(Wrapper());
                              },
                              child: Text("Go back",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.yellowAccent)))
                        ],
                      ),
                    ),
                  ),
                ),
                floatingActionButton: Container(
                  padding: EdgeInsets.fromLTRB(40, 0, 20, 50),
                  child: FloatingActionButton(
                    onPressed: () {
                      reload();
                    },
                    child: Icon(Icons.replay_outlined),
                  ),
                ),
              ));
  }
}
