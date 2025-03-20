import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // استيراد SchedulerBinding
import 'package:quran_project/data/quran_text.dart';
import 'package:quran_project/screens/screenshot_preview.dart';

class SurahDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> surah;
  final int? selectedVerse;

  const SurahDetailsScreen({
    super.key,
    required this.surah,
    this.selectedVerse,
  });

  @override
  State<SurahDetailsScreen> createState() => _SurahDetailsScreenState();
}

class _SurahDetailsScreenState extends State<SurahDetailsScreen> {
  int? highlightedVerse; // تخزين رقم الآية المحددة
  final GlobalKey _selectedVerseKey = GlobalKey();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    highlightedVerse = widget.selectedVerse; // ✅ تحديد الآية المحددة تلقائيًا

    if (widget.selectedVerse != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 300), () {
          _scrollToSelectedVerse();
        });
      });
    }
  }


  void _scrollToSelectedVerse() {
    final keyContext = _selectedVerseKey.currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 500),
        alignment: 0.3, // ✅ جعلها في المنتصف
        curve: Curves.easeInOut,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    int surahNumber = widget.surah["id"];

    // جلب جميع الآيات الخاصة بالسورة المختارة
    List<Map<String, dynamic>> verses =
        quranText
            .where((verse) => verse["surah_number"] == surahNumber)
            .toList()
            .cast<Map<String, dynamic>>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surah["arabic"]),
        backgroundColor: Colors.brown,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/pexels-a-darmel-8164743.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  child: RichText(
                    textAlign: TextAlign.right,
                    text: TextSpan(
                      children: verses.map((verse) {
                        bool isSelected = highlightedVerse == verse["verse_number"];

                        return TextSpan(
                          text: "${verse["content"]} (${verse["verse_number"]})  ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.yellow : Colors.white, // ✅ تحديد اللون فقط للآية المختارة
                            height: 2.5,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              setState(() {
                                highlightedVerse = isSelected ? null : verse["verse_number"];
                              });
                            },
                          children: [
                            if (widget.selectedVerse == verse["verse_number"])
                              WidgetSpan(
                                child: Container(
                                  key: _selectedVerseKey, // ✅ تحديد المفتاح للآية المختارة فقط
                                ),
                              ),
                          ],
                        );
                      }).toList(),

                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
