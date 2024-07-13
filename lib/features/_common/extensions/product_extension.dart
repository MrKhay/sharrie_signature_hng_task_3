import 'dart:math';

import '../../features.dart';

/// [Product] extension
extension ProductExtensions on List<Product> {
  /// Returns all categories in [Product] list
  List<Collection> getCollections() {
    List<String> collectionNames = <String>[];

    for (final Product product in this) {
      for (final String category in product.categories ?? <String>[]) {
        if (!collectionNames.contains(category)) {
          collectionNames.add(category);
        }
      }
    }

    /// Map to [Collection]
    final collections = collectionNames
        .map((name) => Collection(
              id: "${Random().nextInt(1000)} Tag",
              name: name.toUpperFirstLetter(),
              imgUrl: Assets.collection01ImgPath,
            ))
        .toList();

    return collections;
  }

  /// Returns list of [Product]
  List<Product> getJustForYouProducts() {
    shuffle(Random());

    List<Product> justForYou = getRange(0, length ~/ 3).toList();

    /// randomize hero tag
    justForYou = justForYou
        .map((p) => p.copyWith(heroTag: "${Random().nextInt(1000)} Tag"))
        .toList();

    return justForYou;
  }

  /// Returns list of [Product]
  List<Product> getYouMightLikeProducts() {
    shuffle(Random());

    List<Product> youMightLike = getRange(0, length ~/ 2).toList();

    /// randomize hero tag
    youMightLike = youMightLike
        .map((p) => p.copyWith(heroTag: "${Random().nextInt(1000)} Tag"))
        .toList();

    return youMightLike;
  }

  /// Returns all products that matches category
  List<Product> filterByCategory(String category) {
    /// Returns all products if category is all
    if (category == 'all') return this;
    return where((Product p) => p.categories?.contains(category) ?? false)
        .toList();
  }
}
