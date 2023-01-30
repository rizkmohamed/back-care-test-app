import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/cart.dart';
import 'package:flutter_app/app/models/cart_line_item.dart';
import 'package:flutter_app/app/models/checkout_session.dart';
import 'package:flutter_app/bootstrap/app_helper.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:flutter_app/resources/widgets/app_loader_widget.dart';
import 'package:flutter_app/resources/widgets/cached_image_widget.dart';
import 'package:flutter_app/resources/widgets/no_results_for_products_widget.dart';
import 'package:flutter_app/resources/widgets/top_nav_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:woosignal/models/response/products.dart';
import 'package:woosignal/models/response/tax_rate.dart';

import '../../app/controllers/product_detail_controller.dart';
import '../../bootstrap/enums/wishlist_action_enums.dart';
import 'future_build_widget.dart';

class RefreshableScrollContainer extends StatelessWidget {
  const RefreshableScrollContainer(
      {Key? key,
      this.controller,
      this.onRefresh,
      this.onLoading,
      this.products,
      this.onTap,
      this.bannerHeight,
      this.bannerImages,
      this.modalBottomSheetMenu})
      : super(key: key);

  final RefreshController? controller;
  final Function? onRefresh;
  final Function? onLoading;
  final List<Product>? products;
  final Function? onTap;
  final double? bannerHeight;
  final List<String>? bannerImages;
  final Function? modalBottomSheetMenu;

  @override
  Widget build(BuildContext context) => SmartRefresher(
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
              body = Text(trans("No more products"));
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: controller!,
        onRefresh: onRefresh as void Function()?,
        onLoading: onLoading as void Function()?,
        child: (products!.isNotEmpty
            ? StaggeredGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                children: [
                  if (bannerImages!.isNotEmpty)
                    StaggeredGridTile.fit(
                        crossAxisCellCount: 2,
                        child: Container(
                          child: Swiper(
                            itemBuilder: (BuildContext context, int index) {
                              return CachedImageWidget(
                                image: bannerImages![index],
                                fit: BoxFit.contain,
                              );
                            },
                            itemCount: bannerImages!.length,
                            viewportFraction: 0.8,
                            scale: 0.9,
                          ),
                          height: bannerHeight,
                        )),
                  StaggeredGridTile.fit(
                      crossAxisCellCount: 2,
                      child: TopNavWidget(
                          onPressBrowseCategories:
                              modalBottomSheetMenu as dynamic Function()?)),
                  if (products != null)
                    ...products!
                        .map((product) => StaggeredGridTile.fit(
                            crossAxisCellCount: 1,
                            child: Container(
                              height: 200,
                              child: ProductItemContainer(
                                product: product,
                                onTap: onTap,
                              ),
                            )))
                        .toList()
                ],
              )
            : NoResultsForProductsWidget()),
      );
}

class CheckoutRowLine extends StatelessWidget {
  const CheckoutRowLine(
      {Key? key,
      required this.heading,
      required this.leadImage,
      required this.leadTitle,
      required this.action,
      this.showBorderBottom = true})
      : super(key: key);

  final String heading;
  final String? leadTitle;
  final Widget leadImage;
  final Function() action;
  final bool showBorderBottom;

  @override
  Widget build(BuildContext context) => Flexible(
        child: InkWell(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  child: Text(
                    heading,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  padding: EdgeInsets.only(bottom: 8),
                ),
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            leadImage,
                            Expanded(
                              child: Container(
                                child: Text(
                                  leadTitle!,
                                  style: Theme.of(context).textTheme.subtitle1,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                                padding: EdgeInsets.only(left: 15),
                                margin: EdgeInsets.only(right: 10),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                )
              ],
            ),
            padding: EdgeInsets.all(8),
            decoration: showBorderBottom == true
                ? BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black12, width: 1),
                    ),
                  )
                : BoxDecoration(),
          ),
          onTap: action,
          borderRadius: BorderRadius.circular(8),
        ),
        flex: 3,
      );
}

class TextEditingRow extends StatelessWidget {
  const TextEditingRow({
    Key? key,
    this.heading,
    this.controller,
    this.shouldAutoFocus,
    this.keyboardType,
    this.obscureText,
  }) : super(key: key);

  final String? heading;
  final TextEditingController? controller;
  final bool? shouldAutoFocus;
  final TextInputType? keyboardType;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Padding(
                child: AutoSizeText(
                  heading!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: ThemeColor.get(context).primaryContent),
                ),
                padding: EdgeInsets.only(bottom: 2),
              ),
            ),
            Flexible(
              child: TextField(
                controller: controller,
                style: Theme.of(context).textTheme.subtitle1,
                keyboardType: keyboardType ?? TextInputType.text,
                autocorrect: false,
                autofocus: shouldAutoFocus ?? false,
                obscureText: obscureText ?? false,
                textCapitalization: TextCapitalization.sentences,
              ),
            )
          ],
        ),
        padding: EdgeInsets.all(2),
        height: 78,
      );
}

class CheckoutMetaLine extends StatelessWidget {
  const CheckoutMetaLine({Key? key, this.title, this.amount}) : super(key: key);

  final String? title, amount;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Container(
              child: AutoSizeText(title!,
                  style: Theme.of(context).textTheme.bodyText2),
            ),
            flex: 3,
          ),
          Flexible(
            child: Container(
              child:
                  Text(amount!, style: Theme.of(context).textTheme.bodyText1),
            ),
            flex: 3,
          )
        ],
      );
}

List<BoxShadow> wsBoxShadow({double? blurRadius}) => [
      BoxShadow(
        color: Color(0xFFE8E8E8),
        blurRadius: blurRadius ?? 15.0,
        spreadRadius: 0,
        offset: Offset(
          0,
          0,
        ),
      )
    ];

class ProductItemContainer extends StatefulWidget {
  const ProductItemContainer({
    Key? key,
    this.product,
    this.onTap,
    // this.tabFav,
    // this.disFav,
    this.productid,
    this.favButton,
    this.controller,
    this.height,
    this.addToCart,
  }) : super(key: key);

  final Product? product;
  final Function? onTap;
  // final VoidCallback? tabFav;
  // final VoidCallback? disFav;
  final Function? addToCart;
  final Widget? favButton;
  final int? productid;
  final ProductDetailController? controller;
  final double? height;

  @override
  State<ProductItemContainer> createState() => _ProductItemContainerState();
}

class _ProductItemContainerState extends State<ProductItemContainer> {
  @override
  Widget build(BuildContext context) {
    if (widget.product == null) {
      return SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (cxt, constraints) => InkWell(
        child: Container(
          height: constraints.maxHeight,
          child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Stack(
                children: [
                  // Container(
                  //   color: Colors.white,
                  //   width: double.infinity,
                  // ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.5,
                      ),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: CachedImageWidget(
                      image: (widget.product!.images.isNotEmpty
                          ? widget.product!.images.first.src
                          : getEnv("PRODUCT_PLACEHOLDER_IMAGE")),
                      fit: BoxFit.fill,
                      height: constraints.maxHeight * 0.7,
                      width: double.infinity,
                    ),
                  ),
                  // if (widget.product!.onSale! &&
                  //     widget.product!.type != "variable")
                  //   Positioned(
                  //     bottom: 0,
                  //     left: 0,
                  //     right: 0,
                  //     child: Container(
                  //       padding: EdgeInsets.all(3),
                  //       // decoration: BoxDecoration(
                  //       //   color: Colors.white70,
                  //       //   borderRadius: BorderRadius.circular(4),
                  //       // ),
                  //       child: RichText(
                  //         textAlign: TextAlign.center,
                  //         text: TextSpan(
                  //           text: '',
                  //           style: Theme.of(context).textTheme.bodyText1,
                  //           children: <TextSpan>[
                  //             TextSpan(
                  //               text:
                  //                   "${workoutSaleDiscount(salePrice: widget.product!.salePrice, priceBefore: widget.product!.regularPrice)}% ${trans("off")}",
                  //               style: Theme.of(context).textTheme.bodyText2!
                  //               //
                  //               ,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
              Positioned(
                top: constraints.maxHeight * 0.6,
                right: constraints.maxWidth * 0.05,
                left: constraints.maxWidth * 0.05,
                // bottom: 2,
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: constraints.maxHeight * 0.3,
                  alignment: Alignment.bottomCenter,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Center(
                          child: Text(
                            widget.product!.name!,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 3),
                        height: constraints.maxHeight * 0.1,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                "${formatStringCurrency(total: widget.product!.price)} ",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(fontWeight: FontWeight.w600),
                                textAlign: TextAlign.left,
                                maxLines: 1,
                              ),
                              // if (widget.product!.onSale! &&
                              //     widget.product!.type != "variable")
                              //   RichText(
                              //     text: TextSpan(children: [
                              //       TextSpan(
                              //         text: '${trans("Was")}: ',
                              //         style: Theme.of(context)
                              //             .textTheme
                              //             .bodyText1!
                              //             .copyWith(
                              //               fontSize: 11,
                              //             ),
                              //       ),
                              //       TextSpan(
                              //         text: formatStringCurrency(
                              //           total: widget.product!.regularPrice,
                              //         ),
                              //         style: Theme.of(context)
                              //             .textTheme
                              //             .bodyText1!
                              //             .copyWith(
                              //               decoration:
                              //                   TextDecoration.lineThrough,
                              //               color: Colors.grey,
                              //               fontSize: 11,
                              //             ),
                              //       ),
                              //     ]),
                              //   ),
                            ].toList(),
                          ),
                        ),
                      ),
                      RatingBarIndicator(
                        rating: double.parse(widget.product!.averageRating!),
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 15,
                        direction: Axis.horizontal,
                      ),
                    ],
                  ),
                ),
              ),
              if (AppHelper.instance.appConfig!.wishlistEnabled == true)
                Positioned.directional(
                  top: 0,
                  start: 5,
                  textDirection: TextDirection.ltr,
                  child: Container(
                    height: 50,
                    // width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: FutureBuildWidget(
                              asyncFuture:
                                  hasAddedWishlistProduct(widget.productid),
                              onValue: (dynamic isInFavourites) {
                                if (isInFavourites) {
                                  return IconButton(
                                      onPressed: () =>
                                          widget.controller?.toggleWishList(
                                            onSuccess: () => setState(() {}),
                                            wishlistAction:
                                                WishlistAction.remove,
                                          ),
                                      icon: Icon(Icons.favorite,
                                          color: Colors.red));
                                } else {
                                  return IconButton(
                                      onPressed: () => widget.controller
                                          ?.toggleWishList(
                                              onSuccess: () => setState(() {}),
                                              wishlistAction:
                                                  WishlistAction.add),
                                      icon: Icon(
                                        Icons.favorite_border,
                                        // size: 30,
                                      ));
                                }
                              }),
                        ),
                        SizedBox(
                          width: constraints.maxWidth * 0.3,
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.share,
                              // color: Colors.grey.shade300,
                            ))
                      ],
                    ),
                  ),
                ),
              PositionedDirectional(
                  bottom: 3,
                  end: 2,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: ThemeColor.get(context).buttonBackground,
                    child: IconButton(
                      alignment: Alignment.center,
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: 17,
                      ),
                      onPressed: () => widget.addToCart != null
                          ? widget.addToCart!(widget.product)
                          : () {},
                    ),
                  ))
            ],
          ),
        ),
        onTap: () => widget.onTap != null
            ? widget.onTap!(widget.product)
            : Navigator.pushNamed(context, "/product-detail",
                arguments: widget.product),
      ),
    );
  }
}

wsModalBottom(BuildContext context,
    {String? title, Widget? bodyWidget, Widget? extraWidget}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (builder) {
      return SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: ThemeColor.get(context).background,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    title!,
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow:
                          (Theme.of(context).brightness == Brightness.light)
                              ? wsBoxShadow()
                              : null,
                      color: ThemeColor.get(context).background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: bodyWidget,
                  ),
                ),
                if (extraWidget != null) extraWidget
              ],
            ),
          ),
        ),
      );
    },
  );
}

class CheckoutTotal extends StatelessWidget {
  const CheckoutTotal({Key? key, this.title, this.taxRate}) : super(key: key);

  final String? title;
  final TaxRate? taxRate;

  @override
  Widget build(BuildContext context) => FutureBuilder<String>(
        future: CheckoutSession.getInstance
            .total(withFormat: true, taxRate: taxRate),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return AppLoaderWidget();
            default:
              if (snapshot.hasError) {
                return Text("");
              } else {
                return Padding(
                  child: CheckoutMetaLine(title: title, amount: snapshot.data),
                  padding: EdgeInsets.only(bottom: 0, top: 15),
                );
              }
          }
        },
      );
}

class CheckoutTaxTotal extends StatelessWidget {
  const CheckoutTaxTotal({Key? key, this.taxRate}) : super(key: key);

  final TaxRate? taxRate;

  @override
  Widget build(BuildContext context) => FutureBuilder<String>(
        future: Cart.getInstance.taxAmount(taxRate),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return AppLoaderWidget();
            default:
              if (snapshot.hasError) {
                return Text("");
              } else {
                return (snapshot.data == "0"
                    ? Container()
                    : Padding(
                        child: CheckoutMetaLine(
                          title: trans("Tax"),
                          amount: formatStringCurrency(total: snapshot.data),
                        ),
                        padding: EdgeInsets.only(bottom: 0, top: 0),
                      ));
              }
          }
        },
      );
}

class CheckoutSubtotal extends StatelessWidget {
  const CheckoutSubtotal({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) => FutureBuilder<String>(
        future: Cart.getInstance.getSubtotal(withFormat: true),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return AppLoaderWidget();
            default:
              if (snapshot.hasError) {
                return Text("");
              } else {
                return Padding(
                  child: CheckoutMetaLine(
                    title: title,
                    amount: snapshot.data,
                  ),
                  padding: EdgeInsets.only(bottom: 0, top: 0),
                );
              }
          }
        },
      );
}

class CartItemContainer extends StatelessWidget {
  const CartItemContainer({
    Key? key,
    required this.cartLineItem,
    required this.actionIncrementQuantity,
    required this.actionDecrementQuantity,
    required this.actionRemoveItem,
  }) : super(key: key);

  final CartLineItem cartLineItem;
  final void Function() actionIncrementQuantity;
  final void Function() actionDecrementQuantity;
  final void Function() actionRemoveItem;

  @override
  Widget build(BuildContext context) => Container(
        // margin: EdgeInsets.only(bottom: 7),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black12,
              width: 1,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: CachedImageWidget(
                      image: (cartLineItem.imageSrc == ""
                          ? getEnv("PRODUCT_PLACEHOLDER_IMAGE")
                          : cartLineItem.imageSrc),
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.15,
                      fit: BoxFit.contain),
                  flex: 2,
                ),
                Flexible(
                  child: Padding(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          cartLineItem.name!,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                        (cartLineItem.variationOptions != null
                            ? Text(cartLineItem.variationOptions!,
                                style: Theme.of(context).textTheme.bodyText1)
                            : Container()),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              (cartLineItem.stockStatus == "outofstock"
                                  ? trans("Out of stock")
                                  : trans("In Stock")),
                              style: (cartLineItem.stockStatus == "outofstock"
                                  ? Theme.of(context).textTheme.caption
                                  : Theme.of(context).textTheme.bodyText2),
                            ),
                            Text(
                              formatDoubleCurrency(
                                total: parseWcPrice(cartLineItem.total),
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(left: 8),
                  ),
                  flex: 5,
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.remove,
                        color: ThemeColor.get(context).buttonBackground,
                      ),
                      onPressed: actionDecrementQuantity,
                      highlightColor: Colors.transparent,
                    ),
                    Text(cartLineItem.quantity.toString(),
                        style: Theme.of(context).textTheme.headline6),
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: ThemeColor.get(context).buttonBackground,
                      ),
                      onPressed: actionIncrementQuantity,
                      highlightColor: Colors.transparent,
                    ),
                  ],
                ),
                IconButton(
                  alignment: Alignment.centerRight,
                  icon: Icon(Icons.delete_outline,
                      color: Colors.deepOrangeAccent, size: 20),
                  onPressed: actionRemoveItem,
                  highlightColor: Colors.transparent,
                ),
              ],
            )
          ],
        ),
      );
}

class StoreLogo extends StatelessWidget {
  const StoreLogo(
      {Key? key,
      this.height = 100,
      this.width = 100,
      this.placeholder = const CircularProgressIndicator(),
      this.fit = BoxFit.contain,
      this.showBgWhite = true})
      : super(key: key);

  final bool showBgWhite;
  final double height;
  final double width;
  final Widget placeholder;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: showBgWhite ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(5)),
        child: CachedImageWidget(
          image: AppHelper.instance.appConfig!.appLogo,
          height: height,
          placeholder: Container(height: height, width: width),
        ),
      );
}
