import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sharrie_signature/features/cart/presentation/screens/cart_screen.dart';
import '../../../features.dart';

///
class HomeScreen extends ConsumerStatefulWidget {
  /// [Product] screen displays all products
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ProductsScreenState();
}

///
class ProductsScreenState extends ConsumerState<HomeScreen> {
  late ScrollController _scrollController;
  int _currentJustForYouListViewIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var navigator = Navigator.of(context);
    final AsyncValue<ProductsDataType?> productsState =
        ref.watch(productsDataNotifierProvider);

    final ProductsDataNotifier productsNotifier =
        ref.read(productsDataNotifierProvider.notifier);
    return Scaffold(
      appBar: appBar(
          context: context,
          title: kAppName,
          elevation: 0,
          backgroundColor: context.colorScheme.surface,
          style: GoogleFonts.redressed(
            textStyle: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: context.colorScheme.primary,
            ),
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
      backgroundColor: context.colorScheme.surface,
      body: Padding(
        padding:
            const EdgeInsets.only(left: kGap_3, right: kGap_3, top: kGap_2),
        child: productsState.maybeWhen(
          orElse: () => NetworkStateWrapper(child: _loading()),
          loading: () => NetworkStateWrapper(child: _loading()),
          error: (Object error, StackTrace stackTrace) => NetworkStateWrapper(
            child: errorWidget(
              context: context,
              errorMsg: error.toString(),
              retry: productsNotifier.getProducts,
            ),
          ),
          data: (ProductsDataType? data) {
            if (data == null) {
              return errorWidget(
                context: context,
                retry: productsNotifier.getProducts,
              );
            }

            return _body(data);
          },
        ),
      ),
    );
  }

  Widget _loading() {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: context.textTheme.titleLarge?.fontSize,
          height: context.textTheme.titleLarge?.fontSize,
          child: const CircularProgressIndicator.adaptive(),
        ),
        const SizedBox(height: kGap_2),
        Text(
          kFetchingProducts,
          style: context.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.outline,
          ),
        ),
      ],
    ));
  }

  Widget _body(ProductsDataType data) {
    final double width = MediaQuery.of(context).size.width;
    return ListView(
      children: <Widget>[
        ///
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              kWelcomeJane,
              style: context.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w400),
            ),
          ],
        ),
        const SizedBox(height: kGap_2),

        // search container
        _searchContainer(),
        const SizedBox(height: kGap_4),

        // just for you
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              kJustForYou,
              style: GoogleFonts.lora(
                textStyle: context.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),

            // controller
            _justForYouListViewController(
                _scrollController, data.justForYou.length)
          ],
        ),
        const SizedBox(height: kGap_1),
        SizedBox(
          width: width,
          height: context.screenSize.width * 0.65,
          child: _justForYouContainer(data.justForYou, _scrollController),
        ),
        const SizedBox(height: kGap_3),

        /// Deals
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              kDeals,
              style: GoogleFonts.lora(
                textStyle: context.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),

            // view all
            Text(
              kViewAll,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: context.colorScheme.outline,
              ),
            ),
          ],
        ),
        const Divider(),
        const SizedBox(height: kGap_2),

        /// Deals grid
        SizedBox(
          width: width,
          child: _productDealGrid(
              data.deals.getRange(0, data.deals.length ~/ 1.5).toList()),
        ),
        const SizedBox(height: kGap_4),

        /// Collection
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              kOurCollections,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w100,
                letterSpacing: kGap_0,
              ),
            ),
          ],
        ),
        const Divider(),
        const SizedBox(height: kGap_2),

        /// Collections Gride
        SizedBox(
          width: width,
          child: _collectionGrid(data.deals.getCollections()),
        ),

        const SizedBox(height: kGap_4),

        /// You might like
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              kYouMightLike,
              style: GoogleFonts.lora(
                textStyle: context.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),

            // view all
            Text(
              kViewAll,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: context.colorScheme.outline,
              ),
            ),
          ],
        ),
        const Divider(),
        const SizedBox(height: kGap_2),

        ///
        SizedBox(
          width: width,
          child: _productYouMightLikeGrid(data.youMightLike),
        ),
      ],
    );
  }

  Widget _searchContainer() {
    return GestureDetector(
      onTap: () {
        showSearch(
          context: context,
          delegate: ProductListSearchDelegate(),
        );
      },
      child: Container(
        width: context.screenSize.width,
        padding:
            const EdgeInsets.symmetric(horizontal: kGap_1, vertical: kGap_1),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kGap_1),
            border: Border.all(
              color: context.colorScheme.outlineVariant,
            )),
        child: Row(
          children: [
            Icon(Icons.search, color: context.colorScheme.outline),
            const SizedBox(width: kGap_0),
            Text(
              kSearch,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _justForYouContainer(
      List<Product> products, ScrollController controlller) {
    return ListView.separated(
      shrinkWrap: true,
      controller: controlller,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) => const SizedBox(
        width: kGap_3,
      ),
      itemCount: products.length,
      itemBuilder: (_, index) {
        final Product product = products[index];
        return productCard(product, context);
      },
    );
  }

  Widget _productDealGrid(List<Product> products) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: products.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: kGap_3,
        mainAxisSpacing: 0,
        mainAxisExtent: context.screenSize.width * 0.65,
      ),
      itemBuilder: (_, int index) {
        final Product product = products[index];
        return productCard(product, context);
      },
    );
  }

  Widget _productYouMightLikeGrid(List<Product> products) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: products.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: kGap_3,
        mainAxisSpacing: 0,
        mainAxisExtent: context.screenSize.width * 0.65,
      ),
      itemBuilder: (_, int index) {
        final Product product = products[index];
        return productCard(product, context);
      },
    );
  }

  Widget _collectionGrid(List<Collection> collection01) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: collection01.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: kGap_3,
        mainAxisSpacing: 0,
        mainAxisExtent: context.screenSize.width * 0.55,
      ),
      itemBuilder: (_, int index) {
        final Collection collection = collection01[index];
        return _collectionCard(collection, context);
      },
    );
  }

  _justForYouListViewController(
      ScrollController scrollController, int itemCount) {
    final width = MediaQuery.of(context).size.width;
    void scrollToIndex(int index) {
      double offset =
          index * width * 0.45; // Assuming each item has a fixed width of 150.0
      scrollController.animateTo(offset,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

      setState(() {
        _currentJustForYouListViewIndex = index;
      });
    }

    void scrollToNext() {
      if (_currentJustForYouListViewIndex < itemCount - 1) {
        scrollToIndex(_currentJustForYouListViewIndex + 1);
      }
    }

    void scrollToPrevious() {
      if (_currentJustForYouListViewIndex > 0) {
        scrollToIndex(_currentJustForYouListViewIndex - 1);
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          style: IconButton.styleFrom(minimumSize: const Size(kGap_1, kGap_1)),
          onPressed: () {
            scrollToPrevious();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: kGap_2,
          ),
        ),
        IconButton(
          style: IconButton.styleFrom(minimumSize: const Size(kGap_1, kGap_1)),
          onPressed: () {
            scrollToNext();
          },
          icon: const Icon(
            Icons.arrow_forward_ios,
            size: kGap_2,
          ),
        ),
      ],
    );
  }
}

///
Widget productCard(Product product, BuildContext context) {
  final NavigatorState navigator = Navigator.of(context);
  final double width = MediaQuery.of(context).size.width;
  return Container(
    clipBehavior: Clip.hardEdge,
    margin: const EdgeInsets.symmetric(vertical: kGap_2),
    height: width * 0.7,
    width: width * 0.4,
    decoration: const BoxDecoration(),
    child: GestureDetector(
      onTap: () async {
        await navigator.push(
          MaterialPageRoute<dynamic>(
            builder: (BuildContext _) => ProductDetailScreen(
              product: product,
            ),
          ),
        );
      },
      child: Column(
        children: <Widget>[
          Flexible(
              child: Hero(
            tag: product.heroTag,
            child: Container(
              decoration: product.photos != null
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(kGap_1),
                      image: DecorationImage(
                        image: NetworkImage(product.photos!.first),
                        fit: BoxFit.fill,
                      ),
                    )
                  : null,
            ),
          )),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: kGap_1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /// Name
                      Text(
                        product.name,
                        maxLines: 2,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: kGap_0),

                      /// Pricet
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            r'$' + product.currentPrice.toStringAsFixed(2),
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: kGap_2),
                Flexible(
                    flex: 2,
                    child: FittedBox(child: _addToCartBtn(context, product)))
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget _collectionCard(Collection collection, BuildContext context) {
  final NavigatorState navigator = Navigator.of(context);
  final double width = MediaQuery.of(context).size.width;
  return Container(
    clipBehavior: Clip.hardEdge,
    margin: const EdgeInsets.symmetric(vertical: kGap_1),
    height: width * 0.7,
    width: width * 0.4,
    decoration: const BoxDecoration(),
    child: GestureDetector(
      onTap: () async {},
      child: Column(
        children: <Widget>[
          Flexible(
              child: Hero(
            tag: collection.id,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kGap_1),
                image: DecorationImage(
                  image: AssetImage(collection.imgUrl),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          )),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: kGap_1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  collection.name,
                  maxLines: 2,
                  style: context.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget _addToCartBtn(BuildContext context, Product product) {
  final int randInt = Random().nextInt(1000);
  return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding:
            const EdgeInsets.symmetric(horizontal: kGap_1, vertical: kGap_1),
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(kGap_1)),
      ),
      onPressed: () {
        final String id = '$randInt Order';

        final Order order = Order(
          id: id,
          product: product,
          quantity: 1,
          time: DateTime.now(),
        );

        ref.read(ordersDataNotifierProvider.notifier).addNewOrder(order);

        // show snackbar
        context.showSnackBar(
          kOrderAdded,
          type: SnackBarType.success,
        );
      },
      child: Text(
        kAddToCart,
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.primary,
        ),
      ),
    );
  });
}
