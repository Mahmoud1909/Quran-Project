import 'azkar_models.dart';

class Category {
  final String title;
  final List<Azkar> azkarList;

  Category({
    required this.title,
    required this.azkarList,
  });
}
  /// The [jsonList] parameter may contain both direct azkar maps or nested lists.
  /*factory Category.fromJson(String title, List<dynamic> jsonList) {
    final List<Azkar> azkarList = [];
    for (var element in jsonList) {
      if (element is List) {
        // Flatten nested lists.
        for (var item in element) {
          if (item is Map<String, dynamic>) {
            azkarList.add(Azkar.fromJson(item));
          }
        }
      } else if (element is Map<String, dynamic>) {
        azkarList.add(Azkar.fromJson(element));
      }
    }
    return Category(title: title, azkarList: azkarList);
  }*/

