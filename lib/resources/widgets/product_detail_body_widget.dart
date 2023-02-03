import 'package:flutter/material.dart';
import 'package:flutter_app/resources/widgets/grey_border.dart';
import 'package:flutter_app/resources/widgets/product_detail_description_widget.dart';
import 'package:flutter_app/resources/widgets/product_detail_header_widget.dart';
import 'package:flutter_app/resources/widgets/product_detail_image_swiper_widget.dart';
import 'package:flutter_app/resources/widgets/product_detail_related_products_widget.dart';
import 'package:flutter_app/resources/widgets/product_detail_reviews_widget.dart';
import 'package:flutter_app/resources/widgets/product_detail_upsell_widget.dart';
import 'package:woosignal/models/response/products.dart';
import 'package:woosignal/models/response/woosignal_app.dart';

class ProductDetailBodyWidget extends StatelessWidget {
  const ProductDetailBodyWidget({
    Key? key,
    required this.product,
    required this.wooSignalApp,
    this.favIconWidgetsOnImageSwiper,
    this.shareButton,
  }) : super(key: key);

  final Product? product;
  final WooSignalApp? wooSignalApp;
  final Widget? favIconWidgetsOnImageSwiper;
  final Widget? shareButton;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Stack(
            children: [
              ProductDetailImageSwiperWidget(
                product: product,
                onTapImage: (i) => _viewProductImages(context, i),
                favbutton: favIconWidgetsOnImageSwiper,
                sharebutton: shareButton,
              ),
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                  ),
                  GreyBorder(
                      // height: MediaQuery.of(context).size.height * 0.12,
                      child: ProductDetailHeaderWidget(product: product)),
                ],
              ),
            ],
          ),
        ),
        // </Image Swiper>
        GreyBorder(child: ProductDetailDescriptionWidget(product: product)),
        // </Description body>

        GreyBorder(
          child: ProductDetailReviewsWidget(
              product: product, wooSignalApp: wooSignalApp),
        ),
        // </Product reviews>

        if (product != null)
          GreyBorder(
            child: ProductDetailUpsellWidget(
                productIds: product!.upsellIds, wooSignalApp: wooSignalApp),
          ),
        // </You may also like>

        ProductDetailRelatedProductsWidget(
            product: product, wooSignalApp: wooSignalApp),
      ],
    );
  }

  _viewProductImages(BuildContext context, int i) =>
      Navigator.pushNamed(context, "/product-images", arguments: {
        "index": i,
        "images": product!.images.map((f) => f.src).toList()
      });
}
