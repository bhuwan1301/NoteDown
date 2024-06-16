import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notedown/wrapper.dart';
import 'package:notedown/utility.dart';
import 'package:random_string/random_string.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  TextEditingController _title = TextEditingController();
  TextEditingController _note = TextEditingController();

  saveNote() async {
    final user = FirebaseAuth.instance.currentUser;
    String title = _title.text;
    String note = _note.text;
    if (title.trim() == "") {
      MySnackbar.show(
          message: "Title cannot be empty",
          title: "Note",
          duration: Duration(seconds: 1));

      return;
    }
    try {
      if (user != null) {
        MySnackbar.show(
            message: "Saving your note",
            title: "Saving",
            duration: Duration(seconds: 1));

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('notes')
            .add({
          'title': title.trim(),
          'note': note.trim(),
          'noteid': randomAlphaNumeric(10)
        });
        Get.offAll(Wrapper());
      }
    } catch (e) {
      if (e is FirebaseException && e.code == 'unavailable') {
        MySnackbar.show(message: e.toString());
      } else {
        MySnackbar.show(message: e.toString());
      }
      return;
    }
    MySnackbar.show(
        message: "Your note has been saved succesfully", title: "Saved");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Create note",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Title", style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              TextField(
                controller: _title,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _title.clear();
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter title',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Note", style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              TextField(
                maxLines: null,
                controller: _note,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _note.clear();
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter note',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.fromLTRB(20, 10, 20, 10)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.redAccent)),
                  onPressed: () {
                    saveNote();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
