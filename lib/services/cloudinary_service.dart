
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static Future<String?> uploadFile(File file) async {
    const cloudName = 'ddfojnt0e';
    const uploadPreset = 'Chat Alpha';

    final url = Uri.parse('https://api.cloudinary.com/v1_1/\$cloudName/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final data = jsonDecode(resStr);
      return data['secure_url'];
    } else {
      return null;
    }
  }
}
