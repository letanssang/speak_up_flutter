class Category {
  final int categoryID;
  final String name;
  final String translation;
  final String imageUrl;

  Category({
    required this.categoryID,
    required this.name,
    required this.translation,
    required this.imageUrl,
  });

  factory Category.initial() => Category(
        categoryID: 0,
        name: '',
        translation: '',
        imageUrl: '',
      );
}
