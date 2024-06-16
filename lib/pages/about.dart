import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<AboutPage> {
  String? email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "About",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(height: 20),
              TitleText.show("Introduction"),
              SizedBox(height: 5),
              ContentText.show(
                  "Welcome to NoteDown - your go-to app for effortless note-taking and list-making. NoteDown simplifies organization and boosts productivity. Enjoy hassle-free note management with NoteDown today!"),
              SizedBox(height: 10),
              TitleText.show("Developer information"),
              SizedBox(height: 5),
              ContentText.show(
                  "Developed by Bhuwan Chandra Pandey, a student at NSUT Delhi, NoteDown reflects a passion for innovation and practical solutions. Inspired by a personal need for streamlined note-taking, Bhuwan crafted NoteDown to offer users a seamless experience in organizing thoughts and tasks. Dive into NoteDown and experience productivity redefined."),
              SizedBox(height: 10),
              TitleText.show("Contact"),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.email),
                  SizedBox(width: 10),
                  ContentText.show("bhuwancp1301@gmail.com"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TitleText {
  static Widget show(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class ContentText {
  static Widget show(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
      ),
    );
  }
}
