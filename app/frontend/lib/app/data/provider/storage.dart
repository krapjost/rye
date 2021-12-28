import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseStorage storage = FirebaseStorage.instance;

class StorageProvider {
  static Future<void> putMedia(
      XFile video, String uid, String storagePath) async {
    Uint8List data = await video.readAsBytes();
    print('!!!!!! video mimetype is ${video.mimeType}');

    SettableMetadata metadata = SettableMetadata(
      contentType: '${video.mimeType}',
      cacheControl: 'max-age=60',
      customMetadata: <String, String>{'uid': uid},
    );
    var storageRef = storage.ref(storagePath);
    await storageRef.putData(data, metadata);
  }

  static Future<Uint8List?> fetchMediaData(storagePath) async {
    return await storage.ref(storagePath).getData();
  }

  static Future<String> fetchMediaUrl(storagePath) async {
    return await storage.ref(storagePath).getDownloadURL();
  }
}
