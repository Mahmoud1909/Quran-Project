import 'package:flutter/material.dart';
import 'package:quran_project/screens/surah_details_screen.dart';
import 'package:quran_project/data/surah_data.dart';
import 'package:quran_project/search/search.dart';

class QuranWidget extends StatefulWidget {
  const QuranWidget({super.key});

  @override
  _QuranWidgetState createState() => _QuranWidgetState();
}

class _QuranWidgetState extends State<QuranWidget> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _ayahResults = [];
  List<Map<String, dynamic>> _surahResults = [];
  bool _isSearching = false;

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _ayahResults.clear();
        _surahResults.clear();
      });
      return;
    }

    try {
      var searchResult = searchWords(query);
      List<dynamic> ayahResults = searchResult["result"];
      List<Map<String, dynamic>> formattedAyahResults = ayahResults.cast<Map<String, dynamic>>();
      List<Map<String, dynamic>> surahResults = surah
          .where((s) => (s["arabic"] as String).contains(query) ||
          (s["english"] as String).toLowerCase().contains(query.toLowerCase()))
          .toList()
          .cast<Map<String, dynamic>>();

      setState(() {
        _isSearching = true;
        _ayahResults = formattedAyahResults;
        _surahResults = surahResults;
      });
    } catch (e) {
      print("❌ خطأ في البحث: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "images/pexels-a-darmel-8164743.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "بحث في القرآن...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                  ),
                  onChanged: _performSearch,
                ),
              ),
              Expanded(
                child: _isSearching ? _buildSearchResults() : _buildSurahList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_surahResults.isEmpty && _ayahResults.isEmpty) {
      return Center(
        child: Text(
          "غير موجود",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
        ),
      );
    }

    return Container(
      color: Colors.white.withOpacity(0.8),
      child: ListView(
        children: [
          // ✅ عرض أسماء السور إذا وُجدت
          if (_surahResults.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "نتائج السور:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ..._surahResults.map((surahData) => ListTile(
              title: Text(surahData["arabic"]),
              subtitle: Text(surahData["english"] ?? ""),
              onTap: () => _navigateToSurah(surahData["id"], null),
            )),
          ],

          // ✅ عرض الآيات إذا وُجدت
          if (_ayahResults.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "نتائج الآيات:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ..._ayahResults.map((result) {
              final surahData = surah.firstWhere(
                    (s) => s["id"] == result["surah"],
                orElse: () => {},
              );

              if (surahData.isEmpty || result["verse"] == null) return SizedBox.shrink();

              return ListTile(
                title: Text("${surahData["arabic"]} - آية ${result["verse"]}"),
                subtitle: Text(surahData["english"] ?? ""),
                onTap: () => _navigateToSurah(result["surah"], result["verse"]),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildSurahList() {
    return ListView.builder(
      itemCount: surah.length,
      itemBuilder: (context, index) {
        final surahData = surah[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: GestureDetector(
            onTap: () => _navigateToSurah(surahData["id"], null),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          surahData["id"].toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          surahData["arabic"],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "${surahData["english"]} (${surahData["aya"]})",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 3),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      surahData["place"],
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToSurah(int surahNumber, int? verseNumber) {
    var selectedSurah = surah.firstWhere(
          (s) => s["id"] == surahNumber,
      orElse: () => {},
    );

    if (selectedSurah.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SurahDetailsScreen(
            surah: selectedSurah,
            selectedVerse: verseNumber, // ✅ تمرير رقم الآية المختارة
          ),
        ),
      ).then((_) {
        // ✅ عند العودة من شاشة السورة، يتم إيقاف البحث والعودة للوضع الطبيعي
        setState(() {
          _isSearching = false;
          _searchController.clear(); // ✅ مسح النص داخل مربع البحث
          _ayahResults.clear(); // ✅ مسح نتائج البحث الخاصة بالآيات
          _surahResults.clear(); // ✅ مسح نتائج البحث الخاصة بالسور
        });
      });
    } else {
      print("⚠ لم يتم العثور على السورة المطلوبة!");
    }
  }
}
