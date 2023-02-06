import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/controllers/product_loader_controller.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:flutter_app/resources/widgets/app_loader_widget.dart';
import 'package:flutter_app/resources/widgets/cached_image_widget.dart';
import 'package:flutter_app/resources/widgets/cart_icon_widget.dart';
import 'package:flutter_app/resources/widgets/home_drawer_widget.dart';
import 'package:flutter_app/resources/widgets/no_results_for_products_widget.dart';
import 'package:flutter_app/resources/widgets/safearea_widget.dart';
import 'package:flutter_app/resources/widgets/woosignal_ui.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:woosignal/models/response/products.dart';
import 'package:woosignal/models/response/woosignal_app.dart';
import 'package:woosignal/models/response/product_category.dart' as ws_category;
import 'package:woosignal/models/response/products.dart' as ws_product;

import '../../app/controllers/product_detail_controller.dart';
import '../../app/models/cart_line_item.dart';
import '../../bootstrap/app_helper.dart';
import '../../bootstrap/enums/wishlist_action_enums.dart';
import 'future_build_widget.dart';

class NoticHomeWidget extends StatefulWidget {
  NoticHomeWidget({Key? key, required this.wooSignalApp}) : super(key: key);

  final WooSignalApp? wooSignalApp;

  @override
  _NoticHomeWidgetState createState() => _NoticHomeWidgetState();
}

class _NoticHomeWidgetState extends State<NoticHomeWidget> {
  final ProductDetailController controller = ProductDetailController();
  Widget? activeWidget;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final ProductLoaderController _productLoaderController =
      ProductLoaderController();
  List<ws_category.ProductCategory> _categories = [];
  ws_product.Product? _product;

  bool _shouldStopRequests = false, _isLoading = true;

  @override
  void initState() {
    super.initState();
    _home();
  }

  _home() async {
    await fetchProducts();
    await _fetchCategories();
    setState(() {
      _isLoading = false;
    });
  }

  _fetchCategories() async {
    _categories =
        await (appWooSignal((api) => api.getProductCategories(perPage: 100)));
  }

  _modalBottomSheetMenu() {
    wsModalBottom(
      context,
      title: trans("Categories"),
      bodyWidget: ListView.separated(
        itemCount: _categories.length,
        separatorBuilder: (cxt, i) => Divider(),
        itemBuilder: (BuildContext context, int index) => ListTile(
          title: Text(parseHtmlString(_categories[index].name)),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, "/browse-category",
                    arguments: _categories[index])
                .then((value) => setState(() {}));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ws_product.Product> products = _productLoaderController.getResults();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
// final WooSignalApp? _wooSignalApp = AppHelper.instance.appConfig;
    return Scaffold(
      drawer: HomeDrawerWidget(wooSignalApp: widget.wooSignalApp),
      appBar: AppBar(
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: height * 0.03),
          child: StoreLogo(
            height: height * 0.05,
            // showBgWhite: false,
          ),
        ),
        centerTitle: false,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: height * 0.009,
                ),
                child: IconButton(
                  onPressed: () => Navigator.pushNamed(context, "/home-search")
                      .then((value) => setState(() {})),
                  icon: Icon(
                    Icons.search,
                    size: 25,
                  ),
                ),
              ),
              CartIconWidget(),
            ],
          )
          // Center(
          //   child: Container(
          //     margin: EdgeInsets.only(right: 8),
          //     child: InkWell(
          //       splashColor: Colors.transparent,
          //       highlightColor: Colors.transparent,
          //       onTap: _modalBottomSheetMenu,
          //       child: Text(
          //         trans("Categories"),
          //         style: Theme.of(context).textTheme.bodyText2,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
      body: SafeAreaWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (_isLoading)
              Expanded(child: AppLoaderWidget())
            else
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      height: height * 0.15,
                      padding: EdgeInsets.all(8),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (cxt, i) => Divider(
                          thickness: width * 0.05,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            child: SizedBox(
                              width: width * 0.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    // foregroundImage: AssetImage(
                                    //     'public/assets/images/instagram.png'),

                                    child: CachedImageWidget(
                                        fit: BoxFit.cover,
                                        image:
                                            _categories[index].imageUrl ?? ''),

                                    radius: 25,
                                    // backgroundColor: Colors.white,

                                    //  AssetImage(
                                    //     'public/assets/images/instagram.png')),
                                    //     CachedImageWidget(

                                    //   fit: BoxFit.cover,
                                    // )
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      parseHtmlString(_categories[index].name),
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              // Navigator.pop(context);
                              Navigator.pushNamed(context, "/browse-category",
                                      arguments: _categories[index])
                                  .then((value) => setState(() {}));
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5, top: 5),
                      child: Swiper(
                        autoplay: true,
                        // itemHeight: height / 2,
                        // itemWidth: width * 0.9,
                        itemBuilder: (BuildContext context, int index) {
                          return CachedImageWidget(
                            image: widget.wooSignalApp!.bannerImages![index],
                            fit: BoxFit.cover,
                          );
                        },
                        itemCount: widget.wooSignalApp!.bannerImages!.length,
                        viewportFraction: 0.8,
                        scale: 0.9,
                      ),
                      height: height / 4,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05),
                      height: height * 0.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(trans("Recent")),
                          Flexible(
                            child: Text(
                              trans("Products".tr()),
                              style: Theme.of(context).textTheme.headline4,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: height * 0.3,
                      child: SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: true,
                        footer: CustomFooter(
                          builder: (BuildContext context, LoadStatus? mode) {
                            Widget body;
                            if (mode == LoadStatus.idle) {
                              body = Text(trans("pull up load"));
                            } else if (mode == LoadStatus.loading) {
                              body = CupertinoActivityIndicator();
                            } else if (mode == LoadStatus.failed) {
                              body = Text(trans("Load Failed! Click retry!"));
                            } else if (mode == LoadStatus.canLoading) {
                              body = Text(trans("release to load more"));
                            } else {
                              return SizedBox.shrink();
                            }
                            return Container(
                              height: 55.0,
                              child: Center(child: body),
                            );
                          },
                        ),
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        onLoading: _onLoading,
                        child: (products.isNotEmpty
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: false,
                                itemBuilder: (cxt, i) {
                                  return Container(
                                    height: height * 0.6,
                                    width: width / 2.7,
                                    padding: EdgeInsets.only(
                                        bottom: 10, left: 10, right: 10),
                                    child: ProductItemContainer(
                                        addToCart: _addItemToCart,
                                        controller: controller,
                                        productid: products[i].id,
                                        product: products[i],
                                        onTap: _showProduct),
                                  );
                                },
                                itemCount: products.length,
                              )
                            : NoResultsForProductsWidget()),
                      ),
                    ),
                    Container(
                      height: height * 0.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(trans("POPULAR")),
                          Flexible(
                            child: Text(
                              trans("PRODUCTS"),
                              style: Theme.of(context).textTheme.headline4,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      // height: height * 0.4,
                      child: (products.isNotEmpty
                          ? GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 5,
                                      childAspectRatio: 0.7),
                              // scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (cxt, i) {
                                return Container(
                                  margin: EdgeInsetsDirectional.only(end: 10),
                                  // height: height * 0.7,
                                  // width: width / 2.5,
                                  child: ProductItemContainer(
                                      controller: controller,
                                      productid: products[i].id,
                                      // tabFav: () => widget.controller
                                      //     .toggleWishList(
                                      //         onSuccess: () => setState(() {}),
                                      //         wishlistAction:
                                      //             WishlistAction.remove),
                                      // disFav: () => widget.controller
                                      //     .toggleWishList(
                                      //         onSuccess: () => setState(() {}),
                                      //         wishlistAction:
                                      //             WishlistAction.add),
                                      product: products[i],
                                      onTap: _showProduct),
                                );
                              },
                              itemCount: products.length,
                            )
                          : NoResultsForProductsWidget()),
                    )
                  ],
                ),
                flex: 1,
              ),
          ],
        ),
      ),
    );
  }

  _addItemToCart() async {
    if (_product!.type != "simple") {
      // _modalBottomSheetAttributes();
      return;
    }
    if (_product!.stockStatus != "instock") {
      showToastNotification(context,
          title: trans("Sorry"),
          description: trans("This item is out of stock"),
          style: ToastNotificationStyleType.WARNING,
          icon: Icons.local_shipping);
      return;
    }

    await controller.itemAddToCart(
        cartLineItem: CartLineItem.fromProduct(
            quantityAmount: controller.quantity, product: _product!),
        onSuccess: () => setState(() {}));
  }

  _onRefresh() async {
    _productLoaderController.clear();
    await fetchProducts();

    setState(() {
      _shouldStopRequests = false;
      _refreshController.refreshCompleted(resetFooterState: true);
    });
  }

  _onLoading() async {
    await fetchProducts();

    if (mounted) {
      setState(() {});
      if (_shouldStopRequests) {
        _refreshController.loadNoData();
      } else {
        _refreshController.loadComplete();
      }
    }
  }

  Future fetchProducts() async {
    await _productLoaderController.loadProducts(
        hasResults: (result) {
          if (result == false) {
            setState(() {
              _shouldStopRequests = true;
            });
            return false;
          }
          return true;
        },
        didFinish: () => setState(() {}));
  }

  _showProduct(ws_product.Product product) =>
      Navigator.pushNamed(context, "/product-detail", arguments: product);
}
