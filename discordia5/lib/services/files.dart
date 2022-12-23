import 'package:image_picker/image_picker.dart';

class Files{

  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> pickImage() async{
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  static Future<XFile?> takePhoto() async{
    return await _picker.pickImage(source: ImageSource.camera);
  }

}