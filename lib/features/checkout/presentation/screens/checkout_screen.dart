import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features.dart';
import 'order_success_screen.dart';

///
class CheckoutScreen extends ConsumerStatefulWidget {
  /// Shows all orders
  const CheckoutScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CheckoutScreenState();
}

///
class CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Order>?> ordersState =
        ref.watch(ordersDataNotifierProvider);

    return Scaffold(
      appBar: appBar(context: context, title: kMyCart),
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

    return Column(
      children: <Widget>[
        // body
        Expanded(
          child: SizedBox(
            height: height * 0.7,
            child: orders.isEmpty
                ? _emptyOrder()
                : Scrollbar(
                    child: ListView.separated(
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
        ),

        const SizedBox(height: kGap_2),
        // footer
        _checkOutBtn(orders),
      ],
    );
  }

  Widget _emptyOrder() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.shopping_bag_sharp,
            color: context.colorScheme.outline,
          ),
          const SizedBox(height: kGap_1),
          Text(
            kEmptyCart,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkOutBtn(List<Order> orders) {
    final NavigatorState navigator = Navigator.of(context);

    // sum up price of all products
    final double totalPrice = orders.isEmpty
        ? 0
        : orders
            .map((Order order) => order.product.currentPrice * order.quantity)
            .reduce((double total, double price) => total + price);
    final String price = r'$' + totalPrice.toStringAsFixed(2);
    return Hero(
      tag: kOrderSucessTag,
      child: MaterialButton(
        color: context.colorScheme.primary,
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(kGap_2)),
        minWidth: double.infinity,
        padding: const EdgeInsets.all(kGap_2),
        child: Text(
          '$kCheckout $price',
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          if (orders.isEmpty) {
            context.showSnackBar(kCartIsEmpty, type: SnackBarType.error);
            return;
          }

          /// naviagte to order success screen
          navigator.push(MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => OrderSuccessScreen(
              numOfProductOrder: orders.length,
              totalPrice: totalPrice,
            ),
          ));
        },
      ),
    );
  }
}

///
Widget orderCard(BuildContext context, Order order, WidgetRef ref) {
  final double width = MediaQuery.of(context).size.width;
  final double totalPrice = order.product.currentPrice * order.quantity;
  final OrdersDataNotifier ordersNotifier =
      ref.read(ordersDataNotifierProvider.notifier);
  return Container(
    height: double.infinity,
    width: width,
    constraints: BoxConstraints(
      minWidth: width,
      maxWidth: width,
      minHeight: width * 0.25,
      maxHeight: width * 0.3,
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
              borderRadius: BorderRadius.circular(kGap_2),
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
          flex: 3,
          child: SizedBox(
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.all(kGap_1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      order.product.name,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: kGap_1),

                  /// Price
                  Flexible(
                    child: Text(
                      r'$' + totalPrice.toStringAsFixed(2),
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: kGap_1),
                  // Quantity
                  FittedBox(
                    child: CounterWidget(
                      initalValue: order.quantity,
                      onCountChange: (int quantity) {
                        ///
                        ordersNotifier.modifyOrderQuantity(quantity, order.id);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),

        /// remove btn
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kGap_2),
          ),
          child: IconButton(
              onPressed: () async {
                final bool? responce = await showConfirmationDialog(
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
  );
}
