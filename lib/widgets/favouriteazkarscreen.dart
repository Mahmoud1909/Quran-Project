import 'package:flutter/material.dart';
import 'package:quran_project/model/azkar_models.dart';
import 'package:quran_project/model/favourite_items.dart';

class FavouriteAzkarScreen extends StatelessWidget {
  const FavouriteAzkarScreen({Key? key}) : super(key: key);

  IconData _getIconForCategory(String category) {
    switch (category) {
      case "أذكار الصباح":
        return Icons.wb_sunny;
      case "أذكار المساء":
        return Icons.nights_stay;
      case "أذكار بعد السلام من الصلاة المفروضة":
        return Icons.access_time;
      case "تسابيح":
        return Icons.favorite;
      case "أذكار النوم":
        return Icons.bedtime;
      case "أذكار الاستيقاظ":
        return Icons.alarm;
      case "أدعية قرآنية":
        return Icons.book;
      case "أدعية الأنبياء":
        return Icons.star;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar بنفس ستايل HomeScreen مع خلفية بنية وعنوان بالإنجليزية
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.brown,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // صورة الخلفية (بنفس الصورة المستخدمة في HomeScreen)
          Positioned.fill(
            child: Image.asset(
              "images/pexels-a-darmel-8164743.jpg",
              fit: BoxFit.cover,
            ),
          ),
          // محتوى الشاشة مع padding أقل من AppBar (8 فقط)
          favouriteAzkar.isEmpty
              ? const Center(
            child: Text(
              "No favorites yet.",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          )
              : Padding(
            padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 8, 16, 16),
            child: ListView.builder(
              itemCount: favouriteAzkar.length,
              itemBuilder: (context, index) {
                final Azkar azkar = favouriteAzkar[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        _getIconForCategory(azkar.category),
                        size: 24,
                        color: Colors.brown,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          azkar.content,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
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
