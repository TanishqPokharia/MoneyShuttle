import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class CloudStorage {
  static final instance = FirebaseStorage.instance;

  static uploadProfilePicture() async {
    final storageRef = instance.ref();
    final imagesRef = storageRef.child("users");
    final String filePath = r"assets\pic.jpeg";
    File file = File(filePath);
    if (!file.existsSync()) {
      print("file does not exist");
    }
    try {
      await imagesRef.putFile(file).snapshotEvents.listen((event) {
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
