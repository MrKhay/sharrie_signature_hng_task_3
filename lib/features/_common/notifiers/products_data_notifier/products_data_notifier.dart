import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../features.dart';

part 'products_data_notifier.g.dart';

typedef ProductsDataType = ({
  List<Product> deals,
  List<Product> justForYou,
  List<Product> youMightLike,
  List<Product> recentlyViewed,
});

@Riverpod(keepAlive: true)

/// Manages [Product]
class ProductsDataNotifier extends _$ProductsDataNotifier {
  late ProdcutsRepostiory _prodcutsRepostiory;
  late AuthRepository _authRepository;
  Session? session;

  @override
  Future<ProductsDataType?> build() async {
    _prodcutsRepostiory = const ProdcutsRepostiory();
    _authRepository = AuthRepository();

    await getProducts();
    return state.value;
  }

  /// Retrives list of [Product]
  Future<void> getProducts() async {
    state = const AsyncValue<ProductsDataType?>.loading();

    if (session == null) {
      // login
      final CustomResponse<Session> authResponce =
          await _authRepository.login();

      // when error
      if (authResponce.error != null) {
        state = AsyncValue<ProductsDataType?>.error(
          authResponce.error ?? kSomethingWentWrong,
          StackTrace.current,
        );
        return;
      }

      session = authResponce.value;
    }
    // featch products
    final CustomResponse<List<Product>> productsResponce =
        await _prodcutsRepostiory.getProducts(session!);

    // when error
    if (productsResponce.error != null) {
      state = AsyncValue<ProductsDataType?>.error(
          productsResponce.error ?? kSomethingWentWrong, StackTrace.current);
      return;
    }

    List<Product> products = productsResponce.value!;

    /// update state
    state = AsyncValue<ProductsDataType?>.data((
      deals: products,
      justForYou: products.getJustForYouProducts(),
      youMightLike: products.getYouMightLikeProducts(),
      recentlyViewed: const [],
    ));
  }
}
