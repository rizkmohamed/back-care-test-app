import 'package:flutter/material.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:flutter_app/resources/widgets/app_loader_widget.dart';
import 'package:flutter_app/resources/widgets/cached_image_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/products.dart';

import '../../app/controllers/product_detail_controller.dart';
import '../widgets/cart_icon_widget.dart';

class WishListPageWidget extends StatefulWidget {
  final ProductDetailController controller = ProductDetailController();
  @override
  _WishListPageWidgetState createState() => _WishListPageWidgetState();
}

class _WishListPageWidgetState extends State<WishListPageWidget> {
  List<Product> _products = [];
  bool? isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    loadProducts();
  }

  loadProducts() async {
    List<dynamic> favouriteProducts = await getWishlistProducts();
    List<int> productIds =
        favouriteProducts.map((e) => e['id']).cast<int>().toList();
    if (productIds.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    _products = await (appWooSignal((api) => api.getProducts(
          include: productIds,
          perPage: 100,
          status: "publish",
          stockStatus: "instock",
        )));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 244, 245),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 242, 244, 245),
        centerTitle: true,
        title: Text(trans("Wishlist")),
        elevation: 0,
        actions: [
          CartIconWidget(),
        ],
      ),
      body: SafeArea(
          child: isLoading!
              ? AppLoaderWidget()
              : _products.isEmpty && isLoading == false
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 40,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          Text(trans("No items found"),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .setColor(context,
                                      (color) => color!.primaryContent))
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.02),
                      child: ListView(
                        children: [
                          Text(
                            '${_products.length.toString()} ${trans("items")} ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(
                                  vertical: MediaQuery.of(context).size.height *
                                      0.01),
                              itemBuilder: (BuildContext context, int index) {
                                Product product = _products[index];
                                return InkWell(
                                  onTap: () => Navigator.pushNamed(
                                      context, "/product-detail",
                                      arguments: product),
                                  child: Container(
                                    margin: EdgeInsetsDirectional.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 1.5,
                                      ),
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    padding: EdgeInsetsDirectional.only(
                                        end: MediaQuery.of(context).size.width *
                                            0.02),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          // margin: EdgeInsets.only(left: 8),
                                          child: CachedImageWidget(
                                            image: (product.images.isNotEmpty
                                                ? product.images.first.src
                                                : getEnv(
                                                    "PRODUCT_PLACEHOLDER_IMAGE")),
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                          ),
                                          // width: MediaQuery.of(context).size.width / 4,
                                          flex: 2,
                                        ),
                                        Flexible(
                                          flex: 5,
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01,
                                                start: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  product.name!,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  formatStringCurrency(
                                                      total: product.price),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                                RatingBarIndicator(
                                                  rating: double.parse(
                                                      product.averageRating ??
                                                          '2'),
                                                  itemBuilder:
                                                      (context, index) => Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  itemCount: 5,
                                                  itemSize: 18,
                                                  direction: Axis.horizontal,
                                                ),
                                                Divider(
                                                  thickness: 1.5,
                                                ),
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () =>
                                                          _removeFromWishlist(
                                                              product),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          IconButton(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            icon: Icon(
                                                                Icons
                                                                    .delete_outline_rounded,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        115,
                                                                        20,
                                                                        13),
                                                                size: 20),
                                                            onPressed: () =>
                                                                _removeFromWishlist(
                                                                    product),
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                          ),
                                                          Text(trans("Delete"),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6!
                                                                  .copyWith(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          115,
                                                                          20,
                                                                          13))),
                                                        ],
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () =>
                                                          _removeFromWishlist(
                                                              product),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          IconButton(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            icon: Icon(
                                                                Icons
                                                                    .shopping_cart_outlined,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        115,
                                                                        20,
                                                                        13),
                                                                size: 20),
                                                            onPressed: () =>
                                                                _removeFromWishlist(
                                                                    product),
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                          ),
                                                          Text(
                                                              trans(
                                                                  "Move To Bag"),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6!
                                                                  .copyWith(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          115,
                                                                          20,
                                                                          13))),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Container(
                                        //   width: MediaQuery.of(context).size.width / 5,
                                        //   alignment: Alignment.center,
                                        //   child: IconButton(
                                        //     icon: Icon(
                                        //       Icons.favorite,
                                        //       color: Colors.red,
                                        //     ),
                                        //     onPressed: () =>
                                        //         _removeFromWishlist(product),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: _products.length),
                        ],
                      ),
                    )),
    );
  }

  _removeFromWishlist(Product product) async {
    await removeWishlistProduct(product: product);
    showToastNotification(
      context,
      title: trans('Success'),
      icon: Icons.shopping_cart,
      description: trans('Item removed'),
    );
    _products.remove(product);
    setState(() {});
  }

  // _addItemToCart(Product product) async {
  //   if (product.type != "simple") {
  //     _modalBottomSheetAttributes();
  //     return;
  //   }
  //   if (product.stockStatus != "instock") {
  //     showToastNotification(context,
  //         title: trans("Sorry"),
  //         description: trans("This item is out of stock"),
  //         style: ToastNotificationStyleType.WARNING,
  //         icon: Icons.local_shipping);
  //     return;
  //   }

  //   await widget.controller.itemAddToCart(
  //       cartLineItem: CartLineItem.fromProduct(
  //           quantityAmount: widget.controller.quantity, product: product),
  //       onSuccess: () => setState(() {}));
  // }
}
