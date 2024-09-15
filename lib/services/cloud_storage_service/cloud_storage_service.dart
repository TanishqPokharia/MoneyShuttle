import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CloudStorageService {
  static final instance = FirebaseStorage.instance;

  static Future<String> getUserProfilePictureUrl(String msId) async {
    final storageRef = instance.ref();
    final imageRef = storageRef.child("/users/$msId.jpeg");
    final String url = await imageRef.getDownloadURL();
    return url;
  }

  static Future<void> uploadProfilePicture(String filePath, String msId) async {
    final storageRef = instance.ref();
    final imageRef = storageRef.child("/users/$msId.jpeg");
    File file = File(filePath);
    if (!file.existsSync()) {
      print("file does not exist");
    }
    try {
      await imageRef.putFile(file).snapshotEvents.listen((event) {
        print(event.state);
      });

      print("uploaded");
    } on FirebaseException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }
}
