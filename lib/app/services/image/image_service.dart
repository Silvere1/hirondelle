import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/auth_controller.dart';

class ImageService {
  static final _picker = ImagePicker();
  static final _storage = FirebaseStorage.instance.ref("rcUserImages");

  static var uploading = false.obs;

  static Future<File?> getImageForGallery() async {
    XFile? xFile = await _picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      return File(xFile.path);
    } else {
      return null;
    }
  }

  static Future<File?> getImageForCamera() async {
    XFile? xFile = await _picker.pickImage(source: ImageSource.camera);
    if (xFile != null) {
      return File(xFile.path);
    } else {
      return null;
    }
  }

  static uploadFile(String id, bool came) async {
    if (came) {
      File? file = await getImageForCamera();
      if (file != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: file.path,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          compressFormat: ImageCompressFormat.png,
          compressQuality: 100,
          maxHeight: 400,
          maxWidth: 400,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        );
        if (croppedFile != null) {
          UploadTask uploadTask =
              _storage.child(id).putFile(File(croppedFile.path));
          uploading(true);
          uploadTask.whenComplete(() async {
            await getImageLink(id).then((value) {
              AuthController.instance.setImageLink(id: id, link: value);
              uploading(false);
            });
          });
        }
      }
    } else {
      File? file = await getImageForGallery();
      if (file != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: file.path,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          compressFormat: ImageCompressFormat.png,
          compressQuality: 100,
          maxHeight: 400,
          maxWidth: 400,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        );
        if (croppedFile != null) {
          UploadTask uploadTask =
              _storage.child(id).putFile(File(croppedFile.path));
          uploading(true);
          uploadTask.whenComplete(() async {
            await getImageLink(id).then((value) {
              AuthController.instance.setImageLink(id: id, link: value);
              uploading(false);
            });
          });
        }
      }
    }
  }

  static Future<String> getImageLink(String id) async {
    return await _storage.child(id).getDownloadURL();
  }
}
