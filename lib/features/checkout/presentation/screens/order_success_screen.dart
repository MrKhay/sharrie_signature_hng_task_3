import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../sharrie_signature.dart';
import '../../../_common/common.dart';

///
class OrderSuccessScreen extends StatelessWidget {
  /// numbe of products orded
  final int numOfProductOrder;

  /// total price
  final double totalPrice;

  /// Shows number of products ordered and its total price
  const OrderSuccessScreen(
      {super.key, required this.numOfProductOrder, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    final double statusBarPadding = MediaQuery.of(context).padding.top + kGap_2;
    final NavigatorState navigator = Navigator.of(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsetsDirectional.only(top: statusBarPadding),
        alignment: Alignment.center,
        color: Colors.green,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Hero(
                tag: kOrderSucessTag,
                child: Icon(
                  Icons.card_giftcard_sharp,
                )),
            const SizedBox(height: kGap_2),
            Text(
              'Order successful',
              style: context.textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: kGap_2),
            Text(
              r'$' '${totalPrice.toStringAsFixed(2)} spent',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
            const SizedBox(height: kGap_3),
            Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                  /// clear order
                  ref.read(ordersDataNotifierProvider.notifier).clearOrders();

                  /// naviagte to order success screen
                  navigator.pop();
                },
                child: Text(
                  kContinueShopping,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
