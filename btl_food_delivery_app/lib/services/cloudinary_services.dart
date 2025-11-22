import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryServices {
  static String cloudName = "diehvorme";
  static String uploadPreset = "uploadPictures";

  static Future<String?> uploadImage(File file) async {
    final url = "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

    var request = http.MultipartRequest("POST", Uri.parse(url))
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath("file", file.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      final data = jsonDecode(res.body);
      return data["secure_url"]; // Tra ve link anh
    } else {
      print("Upload failed: ${response.statusCode}");
      return null;
    }
  }
}
