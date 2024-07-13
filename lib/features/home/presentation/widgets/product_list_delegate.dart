import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features.dart';

/// [Attendance] Search Delegate
class ProductListSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  PreferredSizeWidget? buildBottom(BuildContext context) {
    return bottomDivider(context);
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.adaptive.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kGap_2, vertical: kGap_1),
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final List<Product> productList =
              ref.watch(productsDataNotifierProvider).value?.deals ??
                  <Product>[];

          // Filtering attendance logs based on query
          final List<Product> filteredProductList =
              productList.where((Product log) {
            final String queryLowercase = query.toLowerCase();
            return log.name.toLowerCase().contains(queryLowercase);
          }).toList();

          return Padding(
              padding: const EdgeInsets.all(kGap_2),
              child: filteredProductList.isEmpty
                  ? const Center(child: Text("No item found"))
                  : GridView.builder(
                      shrinkWrap: true,
                      itemCount: filteredProductList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: kGap_3,
                        mainAxisSpacing: 0,
                        mainAxisExtent: context.screenSize.width * 0.65,
                      ),
                      itemBuilder: (_, int index) {
                        return productCard(filteredProductList[index], context);
                      },
                    ));
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kGap_2, vertical: kGap_1),
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final List<Product> productList =
              ref.watch(productsDataNotifierProvider).value?.deals ??
                  <Product>[];

          // Filtering attendance logs based on query
          final List<Product> filteredProductList =
              productList.where((Product log) {
            final String queryLowercase = query.toLowerCase();
            return log.name.toLowerCase().contains(queryLowercase);
          }).toList();

          return Padding(
              padding: const EdgeInsets.all(kGap_2),
              child: filteredProductList.isEmpty
                  ? const Center(child: Text("No item found"))
                  : GridView.builder(
                      shrinkWrap: true,
                      itemCount: filteredProductList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: kGap_3,
                        mainAxisSpacing: 0,
                        mainAxisExtent: context.screenSize.width * 0.65,
                      ),
                      itemBuilder: (_, int index) {
                        return productCard(filteredProductList[index], context);
                      },
                    ));
        },
      ),
    );
  }
}
