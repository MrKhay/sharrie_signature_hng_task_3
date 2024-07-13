import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sharrie_signature/sharrie_signature.dart';
import '../../../features.dart';
import 'order_success_screen.dart';

///
class CartScreen extends ConsumerStatefulWidget {
  /// Shows all orders
  const CartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CartScreenState();
}

///
class CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Order>?> ordersState =
        ref.watch(ordersDataNotifierProvider);

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: appBar(context: context, title: kCart),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: kGap_3, vertical: kGap_3),
        child: ordersState.maybeWhen(
          orElse: _loading,
          loading: _loading,
          error: (Object error, StackTrace stackTrace) => errorWidget(
            context: context,
            errorMsg: error.toString(),
          ),
          data: (List<Order>? data) {
            if (data == null) {
              return errorWidget(
                context: context,
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

  Widget _body(List<Order> orders) {
    final double height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return ListView(
      children: <Widget>[
        // body
        SizedBox(
          child: orders.isEmpty
              ? _emptyCart()
              : Scrollbar(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: orders.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Order order = orders[index];
                      return orderCard(context, order, ref);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: kGap_1),
                  ),
                ),
        ),

        const SizedBox(height: kGap_4),

        // cart summary
        if (orders.isNotEmpty) _cartSummary(context, orders),

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
          child: _productYouMightLikeGrid(context),
        ),
      ],
    );
  }

  Widget _emptyCart() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SvgPicture.asset(
            Assets.cartSvgPath,
            semanticsLabel: 'My SVG Image',
          ),
          const SizedBox(height: kGap_3),
          Text(
            kYourCartIsEmpty,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: kGap_1),
          Text(
            kYourCartIsEmptyInfo,
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
          const SizedBox(height: kGap_3),
          MaterialButton(
            elevation: 0,
            padding: const EdgeInsets.symmetric(
                horizontal: kGap_3, vertical: kGap_2),
            color: context.colorScheme.primary,
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(kGap_2)),
            onPressed: () => {
              /// navigate back home
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const SharrieSignature()),
                (Route<dynamic> route) => false,
              )
            },
            child: Text(
              kStartShopping,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget _productYouMightLikeGrid(BuildContext context) {
  return Consumer(builder: (context, ref, child) {
    var products =
        ref.read(productsDataNotifierProvider).value?.youMightLike ?? [];
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
  });
}

Widget _cartSummary(BuildContext context, List<Order> orders) {
  var navigator = Navigator.of(context);
  var deliveryCost = orders.length * 0.5;
  // sum up price of all products
  final double totalPrice = orders.isEmpty
      ? 0
      : orders
          .map((Order order) => order.product.currentPrice * order.quantity)
          .reduce((double total, double price) => total + price);
  final String price = r'$' + totalPrice.toStringAsFixed(2);
  return Container(
    padding: const EdgeInsets.all(kGap_2),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(kGap_1),
      border: Border.all(color: context.colorScheme.primary),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Cart sumary
        Text(
          kCartSummary,
          style: GoogleFonts.lora(
            textStyle: context.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: kGap_2),

        // prices
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kGap_4),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    kSubTotal,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.outline,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    price,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.outline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: kGap_2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    kDelivery,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.outline,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    r'$' + deliveryCost.toString(),
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.outline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: kGap_2),
        const Divider(),
        const SizedBox(height: kGap_2),

        // check out
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // cancle btn
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kGap_1, vertical: kGap_1),
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(kGap_1)),
                  side: BorderSide(
                      color: context.colorScheme.onPrimaryContainer)),
              child: Text(
                kCancle,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () async {
                /// navigate back home
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SharrieSignature()),
                  (Route<dynamic> route) => false,
                );
              },
            ),

            const Spacer(),
            // price
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Total amount
                Text(
                  kTotalAmount,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.outline,
                  ),
                ),
                const SizedBox(height: kGap_0),

                /// Price
                Text(
                  price,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Spacer(),

            /// check out btn
            FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: kGap_1, vertical: kGap_1),
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
                /// naviagte to order success screen
                navigator.push(MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => OrderSuccessScreen(
                    numOfProductOrder: orders.length,
                    totalPrice: totalPrice,
                  ),
                ));
              },
            ),
          ],
        ),
      ],
    ),
  );
}

///
Widget orderCard(BuildContext context, Order order, WidgetRef ref) {
  final double width = MediaQuery.of(context).size.width;
  final double totalPrice = order.product.currentPrice * order.quantity;
  final OrdersDataNotifier ordersNotifier =
      ref.read(ordersDataNotifierProvider.notifier);
  return Container(
    height: double.infinity,
    margin: const EdgeInsets.only(bottom: kGap_2),
    width: width,
    constraints: BoxConstraints(
      minWidth: width,
      maxWidth: width,
      minHeight: width * 0.25,
      maxHeight: width * 0.32,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // img
        Flexible(
          flex: 2,
          child: Container(
            height: double.maxFinite,
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(kGap_1),
              image: order.product.photos != null
                  ? DecorationImage(
                      image: NetworkImage(
                        order.product.photos!.first,
                      ),
                      fit: BoxFit.fill,
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(width: kGap_2),
        // details
        Flexible(
          flex: 4,
          child: SizedBox(
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.all(kGap_1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // id
                            Text(
                              order.id,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.onSurface,
                                letterSpacing: kGap_01,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: kGap_1),

                            /// name
                            Text(
                              order.product.name,
                              style: context.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: kGap_2),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // id
                            Text(
                              kUnitePrice,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.outline,
                                letterSpacing: kGap_01,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: kGap_1),

                            /// Price
                            Text(
                              r'$' + totalPrice.toStringAsFixed(2),
                              style: context.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: kGap_1),
                  // Quantity
                  Flexible(
                    child: Row(
                      children: [
                        CounterWidget.small(
                          initialValue: order.quantity,
                          onCountChange: (int quantity) {
                            ///
                            ordersNotifier.modifyOrderQuantity(
                                quantity, order.id);
                          },
                        ),

                        /// remove btn
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kGap_2),
                          ),
                          child: IconButton(
                              onPressed: () async {
                                final bool? responce =
                                    await showConfirmationDialog(
                                  context,
                                  titleText: kRemoveOrderFromCartInfo,
                                  actionTxtColor: context.colorScheme.onPrimary,
                                  actionBtnColor: context.colorScheme.primary,
                                );
                                if (responce == null) return;

                                // when accepted
                                if (responce) {
                                  ref
                                      .read(ordersDataNotifierProvider.notifier)
                                      .removeNewOrder(order);

                                  context.showSnackBar(kOrderRemoved,
                                      type: SnackBarType.success);
                                }
                              },
                              icon: Icon(
                                Icons.delete,
                                color: context.colorScheme.error,
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
