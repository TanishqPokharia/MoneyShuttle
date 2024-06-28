import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class CloudStorage {
  static final instance = FirebaseStorage.instance;

  static uploadProfilePicture() async {
    final storageRef = instance.ref();
    final imagesRef = storageRef.child("users");
    Directory imageDirectory = await getApplicationDocumentsDirectory();
    final String filePath = r"$";
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
