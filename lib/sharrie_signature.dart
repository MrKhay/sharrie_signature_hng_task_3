import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    List screens = [
      const HomeScreen(),
      underConstruction(context),
      underConstruction(context),
      underConstruction(context),
    ];
    return Scaffold(
      body: screens[_selectedIndex],
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
                  Icons.favorite,
                  color: context.colorScheme.outline,
                ),
                selectedIcon: const Icon(Icons.favorite),
                label: kWishlist,
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.person_2_outlined,
                  color: context.colorScheme.outline,
                ),
                selectedIcon: const Icon(Icons.person_2_outlined),
                label: kProfile,
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.search,
                  color: context.colorScheme.outline,
                ),
                selectedIcon: const Icon(Icons.search),
                label: kSearch,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget underConstruction(BuildContext context) {
  return Container(
    color: context.colorScheme.surface,
    width: context.screenSize.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.construction,
          color: context.colorScheme.primary,
        ),
        const SizedBox(height: kGap_1),
        Text(
          kUnderConstruction,
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: kGap_3),
        OutlinedButton(
            onPressed: () async {
              /// navigate back home
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const SharrieSignature()),
                (Route<dynamic> route) => false,
              );
            },
            child: const Text(kGoHome))
      ],
    ),
  );
}
