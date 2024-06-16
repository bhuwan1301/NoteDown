import 'package:notedown/pages/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notedown/pages/createnote.dart';
import 'package:notedown/pages/editnote.dart';
import 'package:notedown/utility.dart';
import 'package:notedown/wrapper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> deleteNote(String noteid) async {
    try {
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .collection('notes')
            .where('noteid', isEqualTo: noteid)
            .get();
        querySnapshot.docs.forEach((doc) async {
          await doc.reference.delete();
        });
      }
    } catch (e) {
      MySnackbar.show(message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Get.to(() => SettingsPage());
              },
              icon: Icon(Icons.settings))
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Note",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
              ),
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
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .collection('notes')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final notes = snapshot.data!.docs;

                  if (notes.length == 0) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                            "Your notes list is empty. \nTry creating a new note.",
                            style: TextStyle(fontSize: 22, color: Colors.grey)),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      String title = note['title'];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                          onPressed: () {
                            Get.to(EditNote(
                                title: note['title'],
                                note: note['note'],
                                noteid: note['noteid']));
                          },
                          child: ListTile(
                            title: Container(
                              width: MediaQuery.of(context).size.width *
                                  0.5, // Set a maximum width for the title
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                overflow: TextOverflow
                                    .ellipsis, // Handle overflow by showing ellipsis
                                maxLines: 1, // Limit to a single line
                              ),
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  Get.defaultDialog(
                                    title: "Delete note?",
                                    middleText:
                                        "Are you sure you want to delete this note?",
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text("No")),
                                      TextButton(
                                          onPressed: () {
                                            deleteNote(note['noteid']);
                                            Get.offAll(() => Wrapper());
                                          },
                                          child: Text("Yes")),
                                    ],
                                  );
                                },
                                icon: Icon(Icons.delete)),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Icon(Icons.add), Text("New")],
        ),
        onPressed: () {
          Get.to(CreateNotePage());
        },
      ),
    );
  }
}
