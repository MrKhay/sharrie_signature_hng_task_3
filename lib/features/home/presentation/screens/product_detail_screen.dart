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
  //
  bool addedToCart = false;
  @override
  Widget build(BuildContext context) {
    var navigator = Navigator.of(context);
    return Scaffold(
      appBar: appBar(
          context: context,
          backgroundColor: context.colorScheme.surfaceContainerHighest,
          bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1), child: SizedBox()),
          title: '',
          leading: IconButton.filled(
            padding: const EdgeInsets.only(left: kGap_0),
            style: IconButton.styleFrom(
                backgroundColor: context.colorScheme.surface),
            onPressed: () {
              navigator.pop();
            },
            icon: Icon(Icons.adaptive.arrow_back),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  navigator.push(MaterialPageRoute(
                    builder: (context) => const CartScreen(),
                  ));
                },
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                ))
          ]),
      body: _body(),
      bottomNavigationBar: _footer(),
    );
  }

  Widget _body() {
    final Product product = widget.product;

    return ListView(
      children: <Widget>[
        /// Image
        Hero(
          tag: product.heroTag,
          child: Container(
            height: context.screenSize.height * 0.4,
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerHighest,
              image: product.photos != null
                  ? DecorationImage(
                      image: NetworkImage(product.photos!.first),
                      fit: BoxFit.contain,
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(height: kGap_2),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: kGap_4,
            vertical: kGap_2,
          ),
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// id
                  Text(
                    product.id.split('').getRange(0, 7).join(),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                      letterSpacing: kGap_01,
                    ),
                  ),

                  /// status
                  Text(
                    kInStock,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      letterSpacing: kGap_01,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: kGap_2),

              /// name
              Text(
                product.name,
                style: context.textTheme.headlineMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: kGap_3),

              // Description
              Text(
                product.description,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: kGap_3),

              // How to use
              const ExpansionTile(
                title: Text(kHowToUse),
                initiallyExpanded: true,
              ),
              const SizedBox(height: kGap_1),

              // How to use
              const ExpansionTile(
                title: Text(kDeliveryAndDropOff),
              ),

              const SizedBox(height: kGap_2),
              // qty  /// Quantity btn
              AbsorbPointer(
                absorbing: addedToCart == true,
                child: CounterWidget.small(
                  initialValue: _quantityCount,
                  onCountChange: (int quantity) {
                    setState(() {
                      _quantityCount = quantity;
                    });
                  },
                ),
              ),
              const SizedBox(height: kGap_1),
            ],
          ),
        ),
      ],
    );
  }

  Widget _footer() {
    final int randInt = Random().nextInt(1000);
    var navigator = Navigator.of(context);
    final height = MediaQuery.of(context).size.height;
    final product = widget.product;

    if (addedToCart == false) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: height * 0.1,
        alignment: Alignment.center,
        color: context.colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: kGap_3),
        margin: const EdgeInsets.only(
          bottom: kGap_3,
          top: kGap_2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Sub
                Text(
                  kSub,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: kGap_0),

                /// Price
                Text(
                  r'$' +
                      (product.currentPrice + _quantityCount)
                          .toStringAsFixed(2),
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.colorScheme.onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            /// Add to cart btn
            Flexible(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(kGap_1)),
                    side: BorderSide(color: context.colorScheme.onPrimary)),
                child: Text(
                  kAddToCart,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () async {
                  final String id = 'RS34$randInt';

                  final Order order = Order(
                    id: id,
                    product: widget.product,
                    quantity: _quantityCount,
                    time: DateTime.now(),
                  );

                  ref
                      .read(ordersDataNotifierProvider.notifier)
                      .addNewOrder(order);

                  // toggle addedToCart
                  setState(() {
                    addedToCart = true;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: height * 0.1,
      alignment: Alignment.center,
      color: context.colorScheme.primaryFixedDim.withOpacity(0.6),
      padding: const EdgeInsets.symmetric(horizontal: kGap_3),
      margin: const EdgeInsets.only(
        bottom: kGap_3,
        top: kGap_2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // cancle btn
          OutlinedButton(
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: kGap_1, vertical: kGap_1),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(kGap_1)),
                side:
                    BorderSide(color: context.colorScheme.onPrimaryContainer)),
            child: Text(
              kCancle,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () async {
              // navigate back
              navigator.pop();
            },
          ),

          const Spacer(),
          // price
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Sub
              Text(
                kUnitePrice,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.outline,
                ),
              ),
              const SizedBox(height: kGap_0),

              /// Price
              Text(
                r'$' +
                    (product.currentPrice + _quantityCount).toStringAsFixed(2),
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),

          /// check out btn
          FilledButton(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  horizontal: kGap_2, vertical: kGap_1),
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(kGap_2)),
            ),
            child: Text(
              kCheckout,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () async {
              navigator.push(MaterialPageRoute(
                builder: (context) => const CartScreen(),
              ));
            },
          ),
        ],
      ),
    );
  }
}
