import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../features.dart';

part 'products_data_notifier.g.dart';

@Riverpod(keepAlive: true)

/// Manages [Product]
class ProductsDataNotifier extends _$ProductsDataNotifier {
  late ProdcutsRepostiory _prodcutsRepostiory;
  late AuthRepository _authRepository;
  Session? session;
  @override
  Future<List<Product>?> build() async {
    _prodcutsRepostiory = const ProdcutsRepostiory();
    _authRepository = AuthRepository();

    await getProducts();
    return state.value;
  }

  /// Retrives list of [Product]
  Future<void> getProducts() async {
    state = const AsyncValue<List<Product>?>.loading();

    if (session == null) {
      // login
      final CustomResponse<Session> authResponce =
          await _authRepository.login();

      // when error
      if (authResponce.error != null) {
        state = AsyncValue<List<Product>?>.error(
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
      state = AsyncValue<List<Product>?>.error(
          productsResponce.error ?? kSomethingWentWrong, StackTrace.current);
      return;
    }

    /// update state
    state = AsyncValue<List<Product>?>.data(productsResponce.value);
  }
}
