import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ImageService {
  final FirebaseStorage _firebaseStorage;

  ImageService({
    required FirebaseStorage firebaseStorage,
  }) : _firebaseStorage = firebaseStorage;

  Future<String?> uploadImageForProfile(
      {required File image, required String uid}) async {
    try {
      final refStorage = _firebaseStorage.ref();
      final refImage =
          refStorage.child('user_images/$uid.jpg'); // need to change this
      await refImage.putFile(image);
      return await refImage.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<String?> uploadImageForEvent(
      {required File image, required String uid}) async {
    try {
      final refStorage = _firebaseStorage.ref();
      final refImage =
          refStorage.child('event_images/$uid.jpg'); // need to change this
      await refImage.putFile(image);
      return await refImage.getDownloadURL();
    } catch (e) {
      return null;
    }
  }
}
