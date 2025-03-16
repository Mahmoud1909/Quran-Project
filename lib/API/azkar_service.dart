// azkar_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quran_project/model/azkar_models.dart';

Future<AzkarResponse?> fetchAzkar() async {
  final url = 'https://raw.githubusercontent.com/nawafalqari/azkar-api/56df51279ab6eb86dc2f6202c7de26c8948331c1/azkar.json';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      return AzkarResponse.fromJson(jsonData);
    } else {
      print('Failed to fetch azkar. Status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('An error occurred: $e');
    return null;
  }
}
