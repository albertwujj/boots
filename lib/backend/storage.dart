import 'package:boots/common_imports.dart';

import 'package:firebase_storage/firebase_storage.dart';


Future<String> uploadImage(File imageFile) async {
  if (imageFile == null) {
    return null;
  }
  int timestamp = new DateTime.now().millisecondsSinceEpoch;
  StorageReference storageReference = FirebaseStorage
      .instance
      .ref()
      .child("img_" + timestamp.toString() + ".jpg");
  StorageUploadTask uploadTask =
  storageReference.putFile(imageFile);
  StorageTaskSnapshot initialRef = await uploadTask.onComplete;
  String downloadUrl = await initialRef.ref.getDownloadURL();
  return downloadUrl;
}
