import 'package:quran_project/data/quran_text.dart';
import 'package:quran_project/quran_text_normal.dart';
import 'package:quran_project/data/surah_data.dart';

Map<String, dynamic> searchWords(String words) {
  List<Map<String, dynamic>> result = [];
  List<Map<String, dynamic>> surahMatches = [];

  // البحث عن اسم السورة
  for (var s in surah) {
    if (s.containsKey('arabic') && s.containsKey('english')) {
      if (s['arabic'].toString().contains(words) || s['english'].toString().toLowerCase().contains(words.toLowerCase())) {
        surahMatches.add({"id": s["id"], "name": s["arabic"], "type": "surah"});
      }
    }
  }

  // البحث عن الكلمات في الآيات
  for (var i in quran_text_normal) {
    if (i.containsKey('content') && i.containsKey('surah_number') && i.containsKey('verse_number')) {
      if (i['content'].toString().toLowerCase().contains(words.toLowerCase())) {
        result.add({"surah": i["surah_number"], "verse": i["verse_number"], "content": i["content"], "type": "verse"});
      }
    }
  }

  if (result.isEmpty) {
    for (var i in quranText) {
      if (i.containsKey('content') && i.containsKey('surah_number') && i.containsKey('verse_number')) {
        if (i['content'].toString().toLowerCase().contains(words.toLowerCase())) {
          result.add({"surah": i["surah_number"], "verse": i["verse_number"], "content": i["content"], "type": "verse"});
        }
      }
    }
  }

  return {
    "occurrences": result.length + surahMatches.length,
    "result": [...surahMatches, ...result],
  };
}
