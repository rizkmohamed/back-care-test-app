import 'package:flutter_app/app/controllers/woosignal_api_loader_controller.dart';
import 'package:woosignal/models/response/products.dart';

class ProductLoaderController extends WooSignalApiLoaderController<Product> {
  ProductLoaderController();

  Future<void> loadProducts(
      {required bool Function(bool hasProducts) hasResults,
      required void Function() didFinish,
      List<int>? productIds = const []}) async {
    await load(
        hasResults: hasResults,
        didFinish: didFinish,
        apiQuery: (api) => api.getProducts(
              perPage: 50,
              page: page,
              include: productIds,
              status: "publish",
              stockStatus: "instock",
            ));
  }
}
