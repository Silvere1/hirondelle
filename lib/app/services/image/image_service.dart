import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_pickers/image_pickers.dart';

import '../../controllers/auth_controller.dart';

class ImageService {
  static final _storage = FirebaseStorage.instance.ref("rcUserImages");

  static var uploading = false.obs;

  static Future<File?> getImageForGallery() async {
    List<Media> medias = await ImagePickers.pickerPaths(
      cropConfig: CropConfig(enableCrop: true),
      showGif: false,
    );

    /*XFile? xFile = await _picker.pickImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.rear,
    );*/
    if (medias.isNotEmpty) {
      return File(medias[0].path!);
    } else {
      return null;
    }
  }

  static Future<File?> getImageForCamera() async {
    Media? media = await ImagePickers.openCamera(
      cropConfig: CropConfig(enableCrop: true),
    );
    /*XFile? xFile = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );*/
    if (media != null) {
      return File(media.path!);
    } else {
      return null;
    }
  }

  static uploadFile(String id, bool came) async {
    if (came) {
      File? file = await getImageForCamera();
      if (file != null) {
        UploadTask uploadTask = _storage.child(id).putFile(File(file.path));
        uploading(true);
        uploadTask.whenComplete(() async {
          await getImageLink(id).then((value) {
            AuthController.instance.setImageLink(id: id, link: value);
            uploading(false);
          });
        });
      }
    } else {
      File? file = await getImageForGallery();
      if (file != null) {
        UploadTask uploadTask = _storage.child(id).putFile(File(file.path));
        uploading(true);
        uploadTask.whenComplete(() async {
          await getImageLink(id).then((value) {
            AuthController.instance.setImageLink(id: id, link: value);
            uploading(false);
          });
        });
        /* CroppedFile? croppedFile = await ImageCropper().cropImage(
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
        }*/
      }
    }
  }

  static Future<String> getImageLink(String id) async {
    return await _storage.child(id).getDownloadURL();
  }
}
