import '../../features.dart';

/// [Product] extension
extension ProductExtensions on List<Product> {
  /// Returns all categories in [Product] list
  List<String> getCategories() {
    final List<String> categories = <String>[];

    // Added default category
    categories.add('all');

    for (final Product product in this) {
      for (final String category in product.categories ?? <String>[]) {
        if (!categories.contains(category)) {
          categories.add(category);
        }
      }
    }
    return categories;
  }

  /// Returns all products that matches category
  List<Product> filterByCategory(String category) {
    /// Returns all products if category is all
    if (category == 'all') return this;
    return where((Product p) => p.categories?.contains(category) ?? false)
        .toList();
  }
}
