import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notedown/wrapper.dart';
import 'package:notedown/utility.dart';
import 'package:notedown/pages/about.dart';
import 'package:notedown/pages/changepassword.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  final user = FirebaseAuth.instance.currentUser;

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

  void deleteAccount() {
    Get.defaultDialog(
      title: "Delete account?",
      middleText: "Are you sure you want to delete your account?",
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text("No"),
        ),
        TextButton(
          onPressed: () {
            Get.back(); // Close the first dialog
            _confirmPasswordDialog(); // Open the confirmation dialog
          },
          child: Text("Yes"),
        ),
      ],
    );
  }

  void _confirmPasswordDialog() {
    String enteredPassword = '';
    String email = user?.email ?? '';
    Get.defaultDialog(
      title: "Enter Password",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            obscureText: true,
            onChanged: (value) {
              enteredPassword = value;
            },
            decoration: InputDecoration(
              labelText: 'Password',
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Check if entered password matches user's password
              if (enteredPassword == null ||
                  enteredPassword.isEmpty ||
                  user == null ||
                  user?.email == null) {
                MySnackbar.show(message: "Invalid password.");
                return;
              }

              AuthCredential credential = EmailAuthProvider.credential(
                email: email,
                password: enteredPassword,
              );
              user?.reauthenticateWithCredential(credential).then((_) {
                // If reauthentication is successful, delete account
                user?.delete().then((_) {
                  Get.offAll(Wrapper());
                });
              }).catchError((error) {
                MySnackbar.show(message: "Incorrect password.");
              });
            },
            child: Text('Delete Account'),
          ),
        ],
      ),
    );
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 25),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.defaultDialog(
                      title: "Log out?",
                      middleText: "Are you sure you want to log out?",
                      actions: [
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text("No")),
                        TextButton(
                            onPressed: () {
                              signout();
                              Get.offAll(() => Wrapper());
                            },
                            child: Text("Yes")),
                      ],
                    );
                  },
                  child: Row(children: [
                    Icon(Icons.logout),
                    SizedBox(width: 10),
                    Text("Log out")
                  ]),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Get.to(ChangePasswordPage());
                  },
                  child: Row(children: [
                    Icon(Icons.password),
                    SizedBox(width: 10),
                    Text("Change password")
                  ]),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Get.to(AboutPage());
                  },
                  child: Row(children: [
                    Icon(Icons.info),
                    SizedBox(width: 10),
                    Text("About")
                  ]),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    deleteAccount();
                  },
                  child: Row(children: [
                    Icon(Icons.delete),
                    SizedBox(width: 10),
                    Text("Delete my account")
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
