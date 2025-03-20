import 'package:flutter/material.dart';
import 'package:quran_project/model/azkar_models.dart';
import 'package:quran_project/model/category.dart';
import 'package:quran_project/model/favourite_items.dart';

class CategoryAzkar extends StatefulWidget {
  final Category category;
  const CategoryAzkar({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryAzkarState createState() => _CategoryAzkarState();
}

class _CategoryAzkarState extends State<CategoryAzkar> {
  // خريطة الأيقونات كما هي
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

  bool isFavourite(Azkar azkar) {
    return favouriteAzkar.contains(azkar);
  }

  void toggleFavourite(Azkar azkar) {
    setState(() {
      if (isFavourite(azkar)) {
        favouriteAzkar.remove(azkar);
      } else {
        favouriteAzkar.add(azkar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Row(
          children: [
            Icon(
              categoryIcons[widget.category.title] ?? Icons.category,
              size: 28,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              widget.category.title,
              style: const TextStyle(fontSize: 22, color: Colors.white),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "images/pexels-a-darmel-8164743.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: ListView.builder(
              itemCount: widget.category.azkarList.length,
              itemBuilder: (context, index) {
                final azkar = widget.category.azkarList[index];
                final fav = isFavourite(azkar);
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      azkar.content,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    subtitle: azkar.description.isNotEmpty
                        ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        azkar.description,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    )
                        : null,
                    trailing: IconButton(
                      icon: Icon(
                        fav ? Icons.favorite : Icons.favorite_border,
                        color: fav ? Colors.brown : Colors.grey,
                      ),
                      onPressed: () {
                        toggleFavourite(azkar);
                      },
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
