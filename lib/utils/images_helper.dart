import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagesHelper{

  static Future<File> getSmallImageFromGallery()async{
    return await ImagePicker.pickImage(source: ImageSource.gallery,maxWidth: 640.0,maxHeight: 480.0).then((file) => file)
        .catchError((error) =>print);
  }

  static Future<File> getBigImageFromGallery()async{
    return await ImagePicker.pickImage(source: ImageSource.gallery,maxWidth: 1920,maxHeight: 1080).then((file) => file)
        .catchError((error) =>print);
  }

  static Future<File> getSmallImageFromCamera() async{
    return await ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 640.0,maxHeight: 480.0).then((file) => file)
        .catchError((error) =>print);
  }

  static Future<File> getBigImageFromCamera() async {
    return await ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 1920.0,maxHeight: 1080.0).then((file) => file)
        .catchError((error) =>print);
  }


  static Future<File> cropImage(File imageFile) async{

    File file;

    if(imageFile != null){
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: imageFile?.path,
          maxHeight: 512,
          maxWidth: 512,
      ).catchError((error) => print);
       file = croppedFile;
    }
    return file;
  }

}