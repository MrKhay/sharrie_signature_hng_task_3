import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/checkout/presentation/screens/checkout_screen.dart';
import 'features/features.dart';

///
class SharrieSignature extends ConsumerStatefulWidget {
  ///
  const SharrieSignature({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuickCartState();
}

class _QuickCartState extends ConsumerState<SharrieSignature> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // load products
    ref.read(productsDataNotifierProvider);

    // load orders
    ref.read(ordersDataNotifierProvider);

    // load network state
    ref.read(networkStateNotifierProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: BorderDirectional(
            top: BorderSide(
              color: context.colorScheme.outline,
              width: 0.11,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
            width: 0.05,
            color: context.colorScheme.outline,
          ))),
          child: NavigationBar(
            backgroundColor: context.colorScheme.surface,
            indicatorColor: Colors.transparent,
            selectedIndex: _selectedIndex,

            onDestinationSelected: (int index) {
              setState(() {
                /// updated index
                _selectedIndex = index;
              });
            },

            // enableFloatingNavBar: false(
            destinations: <Widget>[
              NavigationDestination(
                icon: Icon(
                  Icons.home,
                  color: context.colorScheme.outline,
                ),
                selectedIcon: const Icon(Icons.home),
                label: kHome,
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.shopping_cart_rounded,
                  color: context.colorScheme.outline,
                ),
                selectedIcon: const Icon(Icons.shopping_cart_rounded),
                label: kCheckout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const List<StatefulWidget> _screens = <StatefulWidget>[
  HomeScreen(),
  CheckoutScreen(),
];
