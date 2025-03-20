import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:quran_project/data/surah_data.dart';
import 'package:quran_project/quran_text_normal.dart';
import 'package:screenshot/screenshot.dart';

class ScreenShotPreviewPage extends StatefulWidget {
  final int surahNumber;
  final int firstVerse;
  final int lastVerse;
  final bool isQCF;

  const ScreenShotPreviewPage({
    super.key,
    required this.surahNumber,
    required this.firstVerse,
    required this.lastVerse,
    required this.isQCF,
  });

  @override
  State<ScreenShotPreviewPage> createState() => _ScreenShotPreviewPageState();
}

class _ScreenShotPreviewPageState extends State<ScreenShotPreviewPage> {
  ScreenshotController screenshotController = ScreenshotController();
  Directory? appDir;
  double textSize = 22;
  TextAlign alignment = TextAlign.center;
  int textColorIndex = 0;
  int bgColorIndex = 0;

  List<Color> textColors = [
    Colors.black, Colors.green, Colors.blue, Colors.red,
    Colors.purple, Colors.orange, Colors.teal, Colors.brown
  ];
  List<Color> backgroundColors = [
    Colors.black.withOpacity(0.5), Colors.grey.withOpacity(0.5), Colors.yellow.withOpacity(0.5), Colors.pink.withOpacity(0.5),
    Colors.lightBlue.withOpacity(0.5), Colors.lime.withOpacity(0.5), Colors.cyan.withOpacity(0.5), Colors.deepPurple.withOpacity(0.5)
  ];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    if (!kIsWeb) {
      appDir = await getTemporaryDirectory();
    }
    setState(() {});
  }

  String getVerse(int surahNumber, int verseNumber) {
    var verse = quran_text_normal.firstWhere(
          (element) => element["surah_number"] == surahNumber && element["verse_number"] == verseNumber,
      orElse: () => {"content": "⚠️ الآية غير موجودة"},
    );
    return verse["content"];
  }

  Future<void> _captureAndSave() async {
    final image = await screenshotController.capture();
    if (image != null && !kIsWeb) {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/saved_quran_screenshot.png');
      await file.writeAsBytes(image);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Saved successfully on your device")),
      );
    }
  }

  Future<void> _captureAndShare() async {
    final image = await screenshotController.capture();
    if (image != null && !kIsWeb) {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/shared_quran_screenshot.png');
      await file.writeAsBytes(image);
      Share.shareFiles([file.path], text: "Check out this beautiful Quran verse!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(surah[widget.surahNumber - 1]["name"] ?? "سورة غير معروفة"),
        backgroundColor: Colors.brown,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox.expand(
            child: Image.asset(
              "images/pexels-a-darmel-8164743.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Screenshot(
              controller: screenshotController,
              child: Container(
                padding: EdgeInsets.all(16),
                color: backgroundColors[bgColorIndex],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      surah[widget.surahNumber - 1]["arabic"] ?? "غير معروف",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColors[textColorIndex],
                      ),
                    ),
                    SizedBox(height: 10),
                    RichText(
                      textAlign: alignment,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: textSize,
                          color: textColors[textColorIndex],
                          fontFamily: 'Traditional Arabic',
                        ),
                        children: [
                          for (int i = widget.firstVerse; i <= widget.lastVerse; i++) ...[
                            TextSpan(text: getVerse(widget.surahNumber, i)),
                            TextSpan(
                              text: " (${i}) ",
                              style: TextStyle(fontSize: textSize - 2, color: Colors.grey),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.text_fields),
                      onPressed: () {
                        setState(() {
                          textSize = (textSize == 22) ? 28 : 22;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.format_color_text),
                      onPressed: () {
                        setState(() {
                          textColorIndex = (textColorIndex + 1) % textColors.length;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.format_color_fill),
                      onPressed: () {
                        setState(() {
                          bgColorIndex = (bgColorIndex + 1) % backgroundColors.length;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _captureAndSave,
                      icon: Icon(Icons.download, color: Colors.white),
                      label: Text("Download", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: _captureAndShare,
                      icon: Icon(Icons.share, color: Colors.white),
                      label: Text("Share", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_project/data/surah_data.dart';
import 'package:quran_project/quran_text_normal.dart';
import 'package:screenshot/screenshot.dart';

class ScreenShotPreviewPage extends StatefulWidget {
  final int surahNumber;
  final int firstVerse;
  final int lastVerse;
  final bool isQCF;

  const ScreenShotPreviewPage({
    super.key,
    required this.surahNumber,
    required this.firstVerse,
    required this.lastVerse,
    required this.isQCF,
  });

  @override
  State<ScreenShotPreviewPage> createState() => _ScreenShotPreviewPageState();
}

class _ScreenShotPreviewPageState extends State<ScreenShotPreviewPage> {
  ScreenshotController screenshotController = ScreenshotController();
  Directory? appDir;
  double textSize = 30;
  TextAlign alignment = TextAlign.center;
  int indexOfTheme = 0;

  List<Color> primaryColors = [
    Colors.black, Colors.green, Colors.blue, Colors.red,
    Colors.purple, Colors.orange, Colors.teal, Colors.brown
  ];
  List<Color> backgroundColors = [
    Colors.black.withOpacity(0.5), Colors.green.withOpacity(0.5),
    Colors.blue.withOpacity(0.5), Colors.red.withOpacity(0.5),
    Colors.purple.withOpacity(0.5), Colors.orange.withOpacity(0.5),
    Colors.teal.withOpacity(0.5), Colors.brown.withOpacity(0.5)
  ];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    if (!kIsWeb) {
      appDir = await getTemporaryDirectory();
    }
    setState(() {});
  }

  String getVerse(int surahNumber, int verseNumber) {
    var verse = quran_text_normal.firstWhere(
          (element) => element["surah_number"] == surahNumber && element["verse_number"] == verseNumber,
      orElse: () => {"content": "⚠️ الآية غير موجودة"},
    );
    return verse["content"];
  }

  void _captureAndSave() async {
    final image = await screenshotController.capture();
    if (image != null && !kIsWeb) {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/saved_quran_screenshot.png');
      await file.writeAsBytes(image);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Saved successfully on your device")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(surah[widget.surahNumber - 1]?["name_arabic"] ?? "غير معروف"),
        backgroundColor: Colors.brown,
      ),
      body: Center(
        child: Screenshot(
          controller: screenshotController,
          child: Container(
            color: Color(0xFFF5F1E7),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // إطار اسم السورة
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.brown, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    surah[widget.surahNumber - 1]?["arabic"] ?? "غير معروف",
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Traditional Arabic',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // الآية مع الخلفية المتغيرة
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: backgroundColors[indexOfTheme],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RichText(
                    textAlign: alignment,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: textSize,
                        color: primaryColors[indexOfTheme],
                        fontFamily: 'Traditional Arabic',
                      ),
                      children: [
                        for (int i = widget.firstVerse; i <= widget.lastVerse; i++) ...[
                          TextSpan(text: getVerse(widget.surahNumber, i)),
                          TextSpan(
                            text: " (${i}) ",
                            style: TextStyle(fontSize: textSize - 2, color: Colors.grey),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // تغيير لون الخط والخلفية
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.text_fields, color: Colors.brown),
                      onPressed: () {
                        setState(() {
                          textSize = (textSize == 30) ? 36 : 30;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.format_color_fill, color: Colors.brown),
                      onPressed: () {
                        setState(() {
                          indexOfTheme = (indexOfTheme + 1) % primaryColors.length;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // زر التحميل
                ElevatedButton.icon(
                  onPressed: _captureAndSave,
                  icon: Icon(Icons.download, color: Colors.white),
                  label: Text("Download", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/
