import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notedown/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notedown/wrapper.dart';

class EditNote extends StatefulWidget {
  final String title;
  final String note;
  final String noteid;

  EditNote({
    required this.title,
    required this.note,
    required this.noteid,
  });

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  late TextEditingController _title;
  late TextEditingController _note;
  late String noteid;
  late String original_note;
  late String original_title;

  @override
  void initState() {
    super.initState();
    noteid = widget.noteid;
    _title = TextEditingController(text: widget.title);
    _note = TextEditingController(text: widget.note);
    original_note = widget.note;
    original_title = widget.title;
  }

  saveNote() async {
    final user = FirebaseAuth.instance.currentUser;
    String title = _title.text;
    String note = _note.text;

    if (title.trim() == "") {
      MySnackbar.show(message: "Title cannot be empty", title: "Note");
      return;
    } else if (original_note.trim() == note.trim() &&
        original_title.trim() == title.trim()) {
      MySnackbar.show(
          title: "No changes made",
          message: "Looks like you haven't made any changes in the notes.");
      Get.offAll(Wrapper());
      return;
    }
    try {
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('notes')
            .where('noteid', isEqualTo: noteid)
            .get();
        DocumentSnapshot docSnapshot = querySnapshot.docs[0];
        DocumentReference docRef = docSnapshot.reference;

        await docRef.update({'title': title, 'note': note, 'noteid': noteid});
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Note",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent),
            ),
            Text(
              "Down",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow),
            ),
          ],
        ),
        centerTitle: true,
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
                  // hintText: 'Enter title',
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
                  // hintText: 'Enter note',
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
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 34, 12, 160))),
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
