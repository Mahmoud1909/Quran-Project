import 'package:flutter/material.dart';
import 'package:quran_project/data.dart';
import 'package:quran_project/model/category.dart';
import 'package:quran_project/widgets/CategoryAzkar.dart';

class AzkarWidget extends StatelessWidget {
  const AzkarWidget({Key? key}) : super(key: key);

  // خريطة لربط عناوين الفئات بأيقونات مميزة
  static const Map<String, IconData> categoryIcons = {
    "أذكار الصباح": Icons.wb_sunny,
    "أذكار المساء": Icons.nights_stay,
    "أذكار بعد السلام من الصلاة المفروضة": Icons.access_time,
    "تسابيح": Icons.favorite,
    "أذكار النوم": Icons.bedtime,
    "أذكار الاستيقاظ": Icons.alarm,
    "أدعية قرآنية": Icons.book,
    "أدعية الأنبياء": Icons.star,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: const Text("الأذكار"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,*/
      body: Stack(
        children: [
          // صورة الخلفية
          Positioned.fill(
            child: Image.asset(
              "images/pexels-a-darmel-8164743.jpg",
              fit: BoxFit.cover,
            ),
          ),
          // عرض الفئات على هيئة مربعات (2 في الصف)
          Padding(
            // إزالة المسافة الزائدة من الأعلى
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: GridView.builder(
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 عناصر في الصف
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1, // مربعات متساوية الأبعاد
              ),
              itemBuilder: (context, index) {
                final Category category = categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CategoryAzkar(category: category),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          categoryIcons[category.title] ?? Icons.category,
                          size: 40,
                          color: Colors.brown,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
