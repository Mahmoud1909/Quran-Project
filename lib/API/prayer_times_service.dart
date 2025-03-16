import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quran_project/model/prayer_times_models.dart';

Future<PrayerTimesResponse?> fetchPrayerTimes({
  required String city,
  required String country,
  int method = 4,
}) async {
  // تكوين الرابط باستخدام Uri.https لضمان تشفير المسافات وغيرها من الحروف الخاصة
  final uri = Uri.https('api.aladhan.com', '/v1/timingsByCity', {
    'city': city,
    'country': country,
    'method': method.toString(),
  });

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return PrayerTimesResponse.fromJson(jsonData);
    } else {
      print('Failed to fetch prayer times. Status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('An error occurred: $e');
    return null;
  }
}
