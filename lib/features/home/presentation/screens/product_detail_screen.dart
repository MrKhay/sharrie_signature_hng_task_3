import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features.dart';

///
class ProductDetailScreen extends ConsumerStatefulWidget {
  ///
  final Product product;

  /// [Product] detail screen
  const ProductDetailScreen({super.key, required this.product});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ProductDetailScreenState();
}

///
class ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  // number of product to order
  int _quantityCount = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context: context,
        title: widget.product.categories?.first,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    final Product product = widget.product;
    final int randInt = Random().nextInt(1000);
    final NavigatorState navigator = Navigator.of(context);
    return Column(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            width: double.maxFinite,
            child: ListView(
              children: <Widget>[
                /// Image
                Hero(
                  tag: product.id,
                  child: Container(
                    height: context.screenSize.height * 0.4,
                    margin: const EdgeInsets.all(kGap_3),
                    decoration: BoxDecoration(
                      color: context.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(kGap_2),
                      image: product.photos != null
                          ? DecorationImage(
                              image: NetworkImage(product.photos!.first),
                              fit: BoxFit.contain,
                            )
                          : null,
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: kGap_3,
                    vertical: kGap_2,
                  ),
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      /// name
                      Text(
                        product.name,
                        style: context.textTheme.headlineLarge?.copyWith(
                          color: context.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: kGap_1),

                      /// Price
                      Text(
                        r'$' + product.currentPrice.toString(),
                        style: context.textTheme.titleLarge?.copyWith(
                          color: context.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: kGap_2),

                      // Description
                      Text(
                        kDescription,
                        style: context.textTheme.titleSmall?.copyWith(
                          color: context.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: kGap_1),
                      Text(
                        product.description,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        /// Footer
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
            bottom: kGap_3,
            left: kGap_3,
            right: kGap_3,
            top: kGap_2,
          ),
          child: Row(
            children: <Widget>[
              /// Quantity btn
              CounterWidget(
                initalValue: _quantityCount,
                onCountChange: (int quantity) {
                  _quantityCount = quantity;
                },
              ),
              const SizedBox(width: kGap_2),

              /// Add to cart btn
              Flexible(
                child: MaterialButton(
                  color: context.colorScheme.primary,
                  elevation: 0,
                  shape: const StadiumBorder(),
                  minWidth: double.infinity,
                  padding: const EdgeInsets.all(kGap_2),
                  child: Text(
                    kAddToCart,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    final String id = '$randInt Order';

                    final Order order = Order(
                      id: id,
                      product: product,
                      quantity: _quantityCount,
                      time: DateTime.now(),
                    );

                    ref
                        .read(ordersDataNotifierProvider.notifier)
                        .addNewOrder(order);

                    // show snackbar
                    context.showSnackBar(
                      kOrderAdded,
                      type: SnackBarType.success,
                    );

                    await Future.delayed(const Duration(milliseconds: 200));

                    // naviagtge back
                    navigator.pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
