// ignore_for_file: prefer_final_fields, unused_field, avoid_print, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, prefer_const_declarations, empty_catches, unused_local_variable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

final String USER_COLLECTION = 'users';
final String POST_COLLECTION = 'posts';

class FireBaseServices {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Map? currentUser;
  FireBaseServices();

  Future<bool> registerUser({
    required String name,
    required String email,
    required String pass,
    required File image,
  }) async {
    try {
      UserCredential _userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: pass);
      String _userId = _userCredential.user!.uid;
      String _fileName = Timestamp.now().microsecondsSinceEpoch.toString() +
          p.extension(image.path);
      UploadTask _task =
          _storage.ref('images/$_userId/$_fileName').putFile(image);
      return _task.then((snapshot) async {
        String _downloadURL = await snapshot.ref.getDownloadURL();
        await _db.collection(USER_COLLECTION).doc(_userId).set({
          "name": name,
          "email": email,
          "image": _downloadURL,
        });
        return true;
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> userLogin({
    required String email,
    required String pass,
  }) async {
    try {
      UserCredential _userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      if (_userCredential.user != null) {
        currentUser = await getUserData(uid: _userCredential.user!.uid);
        if (currentUser == null) {
          print("data not found");
          return false;
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("catch $e");
      return false;
    }
  }

  Future<Map> getUserData({required String uid}) async {
    DocumentSnapshot _doc =
        await _db.collection(USER_COLLECTION).doc(uid).get();
    return _doc.data() as Map;
  }

  Future<bool> postImage(File _image) async {
    try {
      String _userId = _auth.currentUser!.uid;
      String _fileName = Timestamp.now().microsecondsSinceEpoch.toString() +
          p.extension(_image.path);
      UploadTask _task =
          _storage.ref('images/$_userId/$_fileName').putFile(_image);
      return await _task.then((snapshot) async {
        String _downloadURL = await snapshot.ref.getDownloadURL();
        await _db.collection(POST_COLLECTION).add({
          "userId": _userId,
          "timestamp": Timestamp.now(),
          "image": _downloadURL,
        });
        return true;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<QuerySnapshot> getPostsForUser() {
    String _userId = _auth.currentUser!.uid;
    return _db
        .collection(POST_COLLECTION)
        .where('userId', isEqualTo: _userId)
        .snapshots();
  }

  Stream<QuerySnapshot> getLatestPost() {
    return _db
        .collection(POST_COLLECTION)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
  
  Future<void> logout()async {
    await _auth.signOut();
  }
}
