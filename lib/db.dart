import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'note.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference notes = FirebaseFirestore.instance.collection('notes');

Future<void> addnote(String text) async {
  DocumentReference documentReference = notes.doc();
  return await documentReference
      .set({
        'noteid': documentReference.id,
        'text': text,
      })
      .then((value) => print("Appointment added successfully"))
      .catchError((error) => print("Failed to add appointment: $error"));
}

Stream<List<note>> getnotes() {
  return notes.snapshots().map(noteListFromSnapshot);
}

List<note> noteListFromSnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    return note(
      noteid: doc.data()['noteid'] ?? '',
      text: doc.data()['text'] ?? '',
    );
  }).toList();
}
